--!native
--!optimize 2

local OP_HALT = 0
local OP_LOAD_CONST = 1
local OP_GET_GLOBAL = 2
local OP_GET_TABLE = 3
local OP_CALL = 4
local OP_SET_TABLE = 5
local OP_EQ = 6
local OP_JUMP = 7
local OP_JUMP_IF_FALSE = 8
local OP_RETURN = 9
local OP_CLOSURE = 10
local OP_FOR_PREP = 11
local OP_FOR_LOOP = 12
local OP_LUACLOSURE = 13
local OP_GET_LOCAL = 14
local OP_SET_LOCAL = 15
local OP_POP = 16
local OP_DUP = 17
local OP_SELF = 18
local OP_ADD = 19
local OP_SUB = 20
local OP_MUL = 21
local OP_DIV = 22

local OPS = {
    HALT = 0, LOAD_CONST = 1, GET_GLOBAL = 2, GET_TABLE = 3,
    CALL = 4, SET_TABLE = 5, EQ = 6, JUMP = 7, JUMP_IF_FALSE = 8,
    RETURN = 9, CLOSURE = 10, FOR_PREP = 11, FOR_LOOP = 12,
    LUACLOSURE = 13, GET_LOCAL = 14, SET_LOCAL = 15,
    POP = 16, DUP = 17, SELF = 18, ADD = 19, SUB = 20, MUL = 21, DIV = 22,
}

local readu8, readu16 = buffer.readu8, buffer.readu16
local writeu8, writeu16 = buffer.writeu8, buffer.writeu16
local b_create, b_len = buffer.create, buffer.len
local t_unpack, t_rem, t_ins, t_create = table.unpack, table.remove, table.insert, table.create

local function compile(instructions)
    local protos = {}
    local function compile_chunk(instrs)
        local optimized = {}
        for i, instr in ipairs(instrs) do
            local op = instr.op
            -- Constant folding: combines two adjacent LOAD_CONST values into one result
            if (op == "ADD" or op == "SUB" or op == "MUL" or op == "DIV") and #optimized >= 2 then
                local p1, p2 = optimized[#optimized], optimized[#optimized - 1]
                if p1.op == "LOAD_CONST" and p2.op == "LOAD_CONST" then
                    t_rem(optimized); t_rem(optimized)
                    local v1, v2 = p2.val, p1.val
                    local res = (op=="ADD" and v1+v2) or (op=="SUB" and v1-v2) or (op=="MUL" and v1*v2) or (v1/v2)
                    t_ins(optimized, {op = "LOAD_CONST", val = res})
                    continue
                end
            end
            t_ins(optimized, instr)
        end

        local constants, constMap, labels, bufferSize = {}, {}, {}, 0
        local function addConst(v)
            if constMap[v] then return constMap[v] end
            local id = #constants; constants[id+1] = v; constMap[v] = id
            return id
        end

        for _, instr in ipairs(optimized) do
            if instr.label then labels[instr.label] = bufferSize
            else
                bufferSize += 1
                local op = instr.op
                if op == "LOAD_CONST" or op == "GET_LOCAL" or op == "SET_LOCAL" or op == "JUMP" or op == "JUMP_IF_FALSE" then bufferSize += 2
                elseif op == "CALL" or op == "LUACLOSURE" then bufferSize += 1
                elseif op == "FOR_PREP" or op == "FOR_LOOP" then bufferSize += 4
                elseif op == "GET_TABLE" or op == "SET_TABLE" or op == "SELF" or op == "CLOSURE" then
                     if op == "SELF" then addConst(instr.key) end
                     bufferSize += 2
                end
            end
        end

        local b = b_create(bufferSize)
        local offset = 0
        for _, instr in ipairs(optimized) do
            if instr.label then continue end
            writeu8(b, offset, OPS[instr.op]); offset += 1
            local op = instr.op
            if op == "LOAD_CONST" then writeu16(b, offset, addConst(instr.val)); offset += 2
            elseif op == "GET_LOCAL" or op == "SET_LOCAL" then writeu16(b, offset, instr.index); offset += 2
            elseif op == "CALL" or op == "LUACREF" then writeu8(b, offset, instr.args or 0); offset += 1
            elseif op == "FOR_PREP" or op == "FOR_LOOP" then
                writeu16(b, offset, instr.index); offset += 2
                writeu16(b, offset, labels[instr.to] or 0); offset += 2
            elseif op == "JUMP" or op == "JUMP_IF_FALSE" then writeu16(b, offset, labels[instr.to] or 0); offset += 2
            elseif op == "SELF" then writeu16(b, offset, addConst(instr.key)); offset += 2
            elseif op == "CLOSURE" then 
                local id = #protos + 1; protos[id] = compile_chunk(instr.body)
                writeu16(b, offset, id); offset += 2
            end
        end
        return { code = b, constants = constants }
    end
    return compile_chunk(instructions), protos
end

local function runVM(proto: any, protos: {any}, env: {[string]: any})
    local stack: any, top: number, base: number, callFrames: {any} = t_create(256), 1, 1, {}
    local pc: number, b: buffer, consts: {any}, len: number = 0, proto.code, proto.constants, b_len(proto.code)

    while pc < len do
        local op = readu8(b, pc); pc += 1

        -- Uses numeric literals in if-else for Luau NCG optimization
        if op == 1 then -- LOAD_CONST
            stack[top] = consts[readu16(b, pc) + 1]; pc += 2; top += 1
        elseif op == 14 then -- GET_LOCAL
            stack[top] = stack[base + readu16(b, pc)]; pc += 2; top += 1
        elseif op == 15 then -- SET_LOCAL
            top -= 1; stack[base + readu16(b, pc)] = stack[top]; pc += 2
        elseif op == 19 then -- ADD
            local b = stack[top-1]
            top -= 1
            local a = stack[top-1]
            stack[top-1] = a + b
        elseif op == 20 then -- SUB
            local b = stack[top-1]
            top -= 1
            local a = stack[top-1]
            stack[top-1] = a - b
        elseif op == 21 then -- MUL
            local b = stack[top-1]
            top -= 1
            local a = stack[top-1]
            stack[top-1] = a * b
        elseif op == 22 then -- DIV
            local b = stack[top-1]
            top -= 1
            local a = stack[top-1]
            stack[top-1] = a / b
        elseif op == 3 then -- GET_TABLE
            top -= 1; stack[top-1] = stack[top-1][stack[top]]
        elseif op == 5 then -- SET_TABLE
            top -= 2; stack[top-1][stack[top]] = stack[top+1]
        elseif op == 18 then -- SELF
            local key = consts[readu16(b, pc) + 1]; pc += 2
            local obj = stack[top-1]
            stack[top] = obj[key]
            top += 1
        elseif op == 4 then -- CALL
            local argsN = readu8(b, pc); pc += 1
            local funcIdx = top - argsN - 1
            local func = stack[funcIdx]
            
            if type(func) == "table" and func.type == "VM_CLOSURE" then
                t_ins(callFrames, {pc=pc, b=b, consts=consts, len=len, base=base, proto=proto})
                proto = func.proto
                b, consts, len, pc, base = proto.code, proto.constants, b_len(proto.code), 0, funcIdx + 1
            else
                local res = func(t_unpack(stack, funcIdx + 1, top - 1))
                top = funcIdx
                stack[top] = res
                top += 1
            end
        elseif op == 9 then -- RETURN
            local res = stack[top-1]
            if #callFrames == 0 then return res end
            
            local f = t_rem(callFrames)
            pc, b, consts, len, base, proto = f.pc, f.b, f.consts, f.len, f.base, f.proto
            stack[base + (top - base) - 1] = res
            top = base + 1
        elseif op == 10 then -- CLOSURE
            stack[top] = {type = "VM_CLOSURE", proto = protos[readu16(b, pc)]}; pc += 2; top += 1
        elseif op == 16 then -- POP
            top -= 1
        elseif op == 17 then -- DUP
            stack[top] = stack[top-1]; top += 1
        elseif op == 6 then -- EQ
            top -= 1; stack[top-1] = (stack[top-1] == stack[top])
        elseif op == 7 then -- JUMP
            pc = readu16(b, pc)
        elseif op == 8 then -- JUMP_IF_FALSE
            top -= 1
            if not stack[top] then pc = readu16(b, pc) else pc += 2 end
        elseif op == 11 then -- FOR_PREP
            local idx = readu16(b, pc); pc += 2
            local jump = readu16(b, pc); pc += 2
            local init, limit, step = stack[base+idx], stack[base+idx+1], stack[base+idx+2]
            if (step > 0 and init > limit) or (step < 0 and init < limit) then pc = jump end
        elseif op == 12 then -- FOR_LOOP
            local idx: number = readu16(b, pc); pc += 2
            local jump: number = readu16(b, pc); pc += 2
            stack[base+idx] += stack[base+idx+2] :: number
            local v: number, lim: number, stp: number = stack[base+idx], stack[base+idx+1], stack[base+idx+2]
            if (stp > 0 and v <= lim) or (stp < 0 and v >= lim) then pc = jump end
        elseif op == 2 then -- GET_GLOBAL
            top -= 1; stack[top] = env[stack[top]]; top += 1
        elseif op == 0 then -- HALT
            break
        end
    end
    return stack[top-1]
end

local ITERATIONS = 1000000
local src = {
    {op = "LOAD_CONST", val = 0},
    {op = "LOAD_CONST", val = 0},
    {op = "LOAD_CONST", val = ITERATIONS},
    {op = "LOAD_CONST", val = 1},

    {op = "FOR_PREP", index = 1, to = "loop_end"},
    {label = "loop_body"},
        {op = "GET_LOCAL", index = 0},
        {op = "LOAD_CONST", val = 5},
        {op = "LOAD_CONST", val = 5},
        {op = "MUL"}, -- Will be folded to 25
        {op = "ADD"},
        {op = "SET_LOCAL", index = 0},
    {op = "FOR_LOOP", index = 1, to = "loop_body"},
    {label = "loop_end"},
    
    {op = "GET_LOCAL", index = 0},
    {op = "HALT"},
}

local a, b = compile(src)
local start = os.clock()
local result = runVM(a, b, {print = print})
print("Final Result:", result)
print("Time:", os.clock() - start, "seconds")