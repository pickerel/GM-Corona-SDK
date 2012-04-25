-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- helpers
_W = display.contentWidth
_H = display.contentHeight

-- imports
local gm = require("gameminion")
local json = require("json")

-- initialize Game Minion
-- Make sure you use your own games keys!
gm = gm.init("00a23d5a344b9021481d207b676ecfb1c2a7459f", "5aad1eb3922a796897b51c79f0b1865170690259")


-- create new user account or login existing
--gm:registerUser("Joe", "Blogs", "jbloggs", "jbloggs@mailmail.com", "password")
gm:loginAPI("jbloggs@mailmail.com", "password")

-- analytics event table
local analyticsEvent = {
	event_type = "Game",
	message = "New Game Started",
	name = "Message Name",
	value = ""
}

-- network save json
local saveData = {
	["Level 1"] = 1,
	["Level 2"] = 3,
	["Level 3"] = 3,
	["Sound"] = false
}

local saveDataBlob = json.encode(saveData)

-- Event listener looking for NetResponse Event
local function netResListener(event)
	print("Event Received: "..event.target)
end

Runtime:addEventListener("netResponse", netResListener)


local function gmCallListener()
	--gm:getMyProfile()
	--gm:getUserProfile("4ead491c5ceaa10001000015")
	--gm:addFriend("4f0be09cc8c1950001000001")
	--gm:getFriends()
	--gm:removeFriend("4f0be09cc8c1950001000001")

	--gm:getLeaderboards()
	--gm:getLeaderboard("4f6f1e7e6b789d0001000008")
	--gm:submitHighScore("4f6f1e736b789d0001000006", 105)
	
	--gm:getAchievements()
	--gm:unlockAchievement("4f705899f903950001000016")
	--gm:getMyAchievements()
	--gm:getAchievement("4f705899f903950001000016")
	--gm:submitEvent(analyticsEvent)
	
	--gm:getNews()
	--gm:getUnreadNews()
	--gm:getNewsArticle("4f70630897e9160001000006")
	
	--gm:registerDevice("11111111111111111")
	--gm:createCloudBox()
	--gm:networkSave(saveDataBlob, "4f8d29770c343d000100000c")
	--gm:getCloudStorage()
	
	--gm:createChatRoom("test2")
	--gm:getChatRooms()
	--gm:getUsersInChatRoom("4f7172b3a821ab0001000002")
	--gm:sendChatMessage("4f7172b3a821ab0001000002", "blah")
	--gm:getChatHistory("4f7172b3a821ab0001000002")
	
	--gm:createMatch()
	--gm:getMatches()
	--gm:acceptChallenge("4f7309d702b79f000100000b")
	--gm:getMatchDetails("4f72c89e7b57140001000002")
	--gm:addPlayerToMatch("4f70674d97e9160001000009", "4f7309d702b79f000100000b")
	--gm:startMatch("4f7309d702b79f000100000b")
	--gm:submitMove("move 3", nil, nil, "4f71ab40b07bbe0001000003")
	--gm:getRecentMoves("4f72c89e7b57140001000002")
	--gm:getAllMoves("4f72c89e7b57140001000002")
	--gm:createRandomChallenge("4f719f4109451e0001000011")
	--gm:createMPChannel("4f719f4109451e0001000011")
	--gm:pollMP("4f7309d702b79f000100000c")
	--gm:pollMP("4f730a0002b79f000100000d")
	
end
timer.performWithDelay(5000, gmCallListener)

local function mpCallListener()
	for i=1, 100 do
		--local content = "move "..i
		--gm:submitMove(content, nil, nil, "4f7309d702b79f000100000b")
		analyticsEvent.value = i
		gm:submitEvent(analyticsEvent)
	end
	--gm:acceptChallenge("4f71b41173860c0001000001")

end
timer.performWithDelay(10000, mpCallListener)
