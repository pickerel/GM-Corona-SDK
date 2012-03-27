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

-- initialize Game Minion
gm = gm.init("1d84d6e6f8dbb1bb191013d9d2ce05ae158203b9", "e3e1e39c52a6ac3a8b409c52e17a2ce2ef572914")


-- create new user account or login existing
--gm:registerUser("Joe", "Blogs", "jbloggs", "jbloggs@mailmail.com", "password")
gm:loginAPI("ahamidi@me.com", "password")
--gm:loginAPI("jbloggs@mailmail.com", "password")

-- analytics event table
local analyticsEvent = {
	event_type = "Game",
	message = "New Game Started",
	name = "Message Name"
}

local function gmCallListener()
	gm:getMyProfile()
	--gm:getUserProfile("4ead491c5ceaa10001000015")
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
	--gm:createChatRoom("test")
	--gm:getUsersInChatRoom("4f7172b3a821ab0001000002")
	--gm:getChatHistory("4f7172b3a821ab0001000002")
	--gm:createMatch()
	--gm:getMatches()
	--gm:acceptChallenge("4f71ab40b07bbe0001000003")
	--gm:getMatchDetails("4f71ab40b07bbe0001000003")
	--gm:addPlayerToMatch("4f70674d97e9160001000009", "4f71ab40b07bbe0001000003")
	--gm:startMatch("4f71ab40b07bbe0001000003")
	--gm:submitMove("move 3", nil, nil, "4f71ab40b07bbe0001000003")
	--gm:getRecentMoves("4f719bd309451e000100000d")
	--gm:createRandomChallenge("4f719f4109451e0001000011")
	--gm:createMPChannel("4f719f4109451e0001000011")
	--gm:pollMP("4f71ab40b07bbe0001000004")
	--gm:pollMP("4f71ab83b07bbe0001000005")
	
end
timer.performWithDelay(5000, gmCallListener)

local function mpCallListener()
	--gm:submitMove("move 3", nil, nil, "4f719f4109451e0001000011")
end
timer.performWithDelay(10000, mpCallListener)
