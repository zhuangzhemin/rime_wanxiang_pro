--@amzxyz https://github.com/amzxyz/rime_wanxiang_pinyin
--由于comment_format不管你的表达式怎么写，只能获得一类输出，导致的结果只能用于一个功能类别
--如果依赖lua_filter载入多个lua也只能实现一些单一的、不依赖原始注释的功能，有的时候不可避免的发生一些逻辑冲突
--所以此脚本专门为了协调各式需求，逻辑优化，实现参数自定义，功能可开关，相关的配置跟着方案文件走，如下所示：
--将如下相关位置完全暴露出来，注释掉其它相关参数--
--  comment_format: {comment}   #将注释以词典字符串形式完全暴露，通过super_comment.lua完全接管。
--  spelling_hints: 10          # 将注释以词典字符串形式完全暴露，通过super_comment.lua完全接管。
--在方案文件顶层置入如下设置--
--#Lua 配置: 超级注释模块
--super_comment:                   # 超级注释，子项配置 true 开启，false 关闭
--  fuzhu_code: true                    # 启用辅助码提醒，用于辅助输入练习辅助码，成熟后可关闭
--  candidate_length: 1                 # 候选词辅助码提醒的生效长度，0为关闭  但同时清空其它，应当使用上面开关来处理    
--  fuzhu_type: zrm                     # 用于匹配对应的辅助码注释显示，可选显示类型有：moqi, flypy, zrm, jdh, cj, tiger, wubi, hanxin 选择一个填入，应与上面辅助码类型一致
--
--  corrector: true                     # 启用错音错词提醒，例如输入 geiyu 给予 获得 jiyu 提示
--  corrector_type: "{comment}"         # 新增一个显示类型，比如"【{comment}】" 

local function utf8_sub(s, i, j)
   i = i or 1
   j = j or -1
   if i < 1 or j < 1 then
      local n = utf8.len(s)
      if not n then return nil end
      if i < 0 then i = n + 1 + i end
      if j < 0 then j = n + 1 + j end
      if i < 0 then i = 1 elseif i > n then i = n end
      if j < 0 then j = 1 elseif j > n then j = n end
   end
   if j < i then return "" end
   i = utf8.offset(s, i)
   j = utf8.offset(s, j + 1)
   if i and j then
      return s:sub(i, j - 1)
   elseif i then
      return s:sub(i)
   else
      return ""
   end
end

local function truncate_comment(comment)
  local MAX_LENGTH = 80
  local MAX_UTF8_LENGTH = 40
  local result = comment:gsub("\\n", ' ')
  if #result > MAX_LENGTH then
    result = utf8_sub(result, 1, MAX_UTF8_LENGTH)
  end
  return result
end

-- 定义 fuzhu_type 与匹配模式的映射表
local patterns = {
    tone = "([^;]*);",
    moqi = "[^;]*;([^;]*);",
    flypy = "[^;]*;[^;]*;([^;]*);",
    zrm = "[^;]*;[^;]*;[^;]*;([^;]*);",
    jdh = "[^;]*;[^;]*;[^;]*;[^;]*;([^;]*);",
    cj = "[^;]*;[^;]*;[^;]*;[^;]*;[^;]*;([^;]*);",
    tiger = "[^;]*;[^;]*;[^;]*;[^;]*;[^;]*;[^;]*;([^;]*);",
    wubi = "[^;]*;[^;]*;[^;]*;[^;]*;[^;]*;[^;]*;[^;]*;([^;]*);",
    hanxin = "[^;]*;[^;]*;[^;]*;[^;]*;[^;]*;[^;]*;[^;]*;[^;]*;([^;]*)"
}
-- #########################
-- # 辅助码拆分提示模块 (chaifen)
-- #########################
local CF = {}
function CF.init(env)
    -- 初始化拆分词典（reverse.bin 形式）
    env.chaifen_dict = ReverseLookup("wanxiang_lookup")
end
function CF.fini(env)
    env.chaifen = nil
    collectgarbage()
 end
-- 拆分功能：返回拆分注释
function CF.run(cand, env, initial_comment)
    local dict = env.chaifen_dict
    if not dict then return nil end

    local append = dict:lookup(cand.text)
    if append ~= "" then
        if initial_comment and initial_comment ~= "" then
            return append
        end
    end
    return nil
end
-- #########################
-- # 错音错字提示模块 (Corrector)
-- #########################
local CR = {}
local corrections_cache = nil  -- 用于缓存已加载的词典

function CR.init(env)
    local auto_delimiter = env.settings.auto_delimiter or " "
    local corrections_file_path = rime_api.get_user_data_dir() .. "/cn_dicts/corrections.dict.yaml"

    -- 使用设置好的 corrector_type 和样式
    CR.style = env.settings.corrector_type or '{comment}'
    if corrections_cache then
        CR.corrections = corrections_cache
        return
    end

    local corrections = {}
    local file = io.open(corrections_file_path, "r")

    if file then
        for line in file:lines() do
            if not line:match("^#") then
                local text, code, weight, comment = line:match("^(.-)\t(.-)\t(.-)\t(.-)$")
                if text and code then
                    text = text:match("^%s*(.-)%s*$")
                    code = code:match("^%s*(.-)%s*$")
                    comment = comment and comment:match("^%s*(.-)%s*$") or ""
                    -- 用自动分隔符替换空格
                    comment = comment:gsub("%s+", auto_delimiter)
                    code = code:gsub("%s+", auto_delimiter)
                    corrections[code] = { text = text, comment = comment }
                end
            end
        end
        file:close()
        corrections_cache = corrections
        CR.corrections = corrections
    end
end
function CR.run(cand, env, initial_comment)
    -- 使用候选词的 comment 作为 code，在缓存中查找对应的修正
    local correction = nil
    if corrections_cache then
        correction = corrections_cache[cand.comment]
    end
    if correction and cand.text == correction.text then
        -- 用新的注释替换默认注释
        local final_comment = CR.style:gsub("{comment}", correction.comment)
        return final_comment
    end

    return nil
end

-- #########################
-- # 辅助码提示模块 (Fuzhu)
-- #########################

local FZ = {}
function FZ.run(cand, env, initial_comment)
    local length = utf8.len(cand.text)
    local final_comment = nil

    -- 确保候选词长度检查使用从配置中读取的值
    if env.settings.fuzhu_code_enabled and length <= env.settings.candidate_length then
        local fuzhu_comments = {}
        local segments = {}
        -- 先用空格将分隔符分成多个片段
        local auto_delimiter = env.settings.auto_delimiter or " "
        for segment in string.gmatch(initial_comment, "[^" .. auto_delimiter .. "]+") do
            table.insert(segments, segment)
        end

        -- 获取当前 fuzhu_type 对应的模式
        local pattern = patterns[env.settings.fuzhu_type]

        if pattern then
            -- 提取匹配内容
            for _, segment in ipairs(segments) do
                local match = segment:match(pattern)
                if match then
                    table.insert(fuzhu_comments, match)
                end
            end
        else
            -- 如果类型不匹配，返回空字符串
            return ""
        end

        -- 将提取的拼音片段用空格连接起来
        if #fuzhu_comments > 0 then
            final_comment = table.concat(fuzhu_comments, "/")
        end
    else
        -- 如果候选词长度超过指定值，返回空字符串
        final_comment = ""
    end

    return final_comment or ""  -- 确保返回最终值
end
-- ################################
-- 部件组字返回的注释（radical_pinyin）
-- ################################
local AZ = {}
-- 处理函数，只负责处理候选词的注释
function AZ.run(cand, env, initial_comment)
    local final_comment = nil  -- 初始化最终注释为空
    local fuzhu_comments = {}

    -- 获取当前 fuzhu_type 对应的模式
    local pattern = patterns[env.settings.fuzhu_type]

    if pattern then
        local pinyins = {}  -- 存储多个拼音
        local fuzhu = nil   -- 辅助码

        -- 使用空格将注释分割成多个片段
        local segments = {}
        for segment in initial_comment:gmatch("[^%s]+") do
            table.insert(segments, segment)
        end

        -- 遍历分割后的片段，提取拼音和辅助码
        for _, segment in ipairs(segments) do
            local pinyin = segment:match("^[^;]+")  -- 提取注释中的拼音部分
            local fz = segment:match(pattern)  -- 根据模式提取对应的辅助码

            if pinyin then
                table.insert(pinyins, pinyin)  -- 收集拼音
            end

            if fz then
                fuzhu = fz  -- 获取第一个辅助码
            end
        end

        -- 生成最终注释
        if #pinyins > 0 and fuzhu then
            local pinyin_str = table.concat(pinyins, ",")  -- 用逗号分隔多个拼音
            final_comment = string.format("〔音%s 辅%s〕", pinyin_str, fuzhu)
        end
    end
    
    return final_comment or ""  -- 确保返回最终值
end
-- 主函数：根据优先级处理候选词的注释
local ZH = {}
function ZH.init(env)
    local config = env.engine.schema.config
    local delimiter = config:get_string('speller/delimiter') or " '"
    local auto_delimiter = delimiter:sub(1, 1)
-- 检查开关状态
    local is_fuzhu_enabled = env.engine.context:get_option("fuzhu_switch")
    local is_chaifen_enabled = env.engine.context:get_option("chaifen_switch")
-- 设置辅助码功能
    env.settings = {
        delimiter = delimiter,
        auto_delimiter = auto_delimiter,
        corrector_enabled = config:get_bool("super_comment/corrector") or true,  -- 错音错词提醒功能
        corrector_type = config:get_string("super_comment/corrector_type") or "{comment}",  -- 提示类型
        fuzhu_code_enabled = is_fuzhu_enabled,  -- 辅助码提醒功能通过开关控制
        chaifen_enabled = is_chaifen_enabled,  -- 辅助码拆分提醒功能通过开关控制
        candidate_length = tonumber(config:get_string("super_comment/candidate_length")) or 1,  -- 候选词长度
        fuzhu_type = config:get_string("super_comment/fuzhu_type") or ""  -- 辅助码类型
    }
end
function ZH.func(input, env)
    -- 初始化
    ZH.init(env)
    CR.init(env)
    CF.init(env)

    -- 声明反查模式的 tag 状态
    local seg = env.engine.context.composition:back()
    env.is_radical_mode = seg and (
        seg:has_tag("radical_lookup")
        or seg:has_tag("reverse_stroke")
        or seg:has_tag("add_user_dict")
    ) or false

    local input_str = env.engine.context.input or ""
    local index = 0
    for cand in input:iter() do
        index = index + 1
        local initial_comment = cand.comment
        local final_comment = initial_comment
    
        -- 辅助码处理
        if env.settings.fuzhu_code_enabled then
            local fz_comment = FZ.run(cand, env, initial_comment)
            if fz_comment then
                final_comment = fz_comment
            end
        else
            if final_comment ~= initial_comment then
                -- 有其他模块修改过注释，保留
            elseif input_str:match("//") and index == 1 then  --匹配pin造词状态
            elseif input_str:match("^[VRNU/]") then
                -- 输入包含 //，首选项保留注释
            elseif cand.text:match("^[%a%d '%-]+$") then -- cand.text contains only letters/numbers/ /'/-
                -- 候选词文本只包含字母/数字/空格/'/-等英文词组字符，保留
            else
                -- 其他情况清空
                final_comment = ""
            end
        end
        -- 拆分辅助码
        if env.settings.chaifen_enabled then
            local cf_comment = CF.run(cand, env, initial_comment)
            if cf_comment then
                final_comment = cf_comment
            end
        end

        -- 错音错词提示
        if env.settings.corrector_enabled then
            local cr_comment = CR.run(cand, env, initial_comment)
            if cr_comment then
                final_comment = cr_comment
            end
        end

        -- 部件组字注释
        if env.is_radical_mode then
            local az_comment = AZ.run(cand, env, initial_comment)
            if az_comment then
                final_comment = az_comment
            end
        end

        final_comment = truncate_comment(final_comment)

        -- 更新最终注释
        if final_comment ~= initial_comment then
            cand:get_genuine().comment = final_comment
        end

        yield(cand)
    end
end

return {
    CR = CR,
    CF = CF,
    FZ = FZ,
    AZ = AZ,
    ZH = ZH,
    func = ZH.func
}
