-------------------------------------------------
--
-- gameminion.lua
--
-- Official Game Minion Corona SDK Library
--
-- Author: Ali Hamidi, Game Minion
--
-------------------------------------------------

--[[

Copyright (C) 2012 Ali Hamidi. All Rights Reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in the
Software without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so, subject to the
following conditions:

The above copyright notice and this permission notice shall be included in all copies
or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

]]--


local gameminion = {}
local gameminion_mt = { __index = gameminion }	-- metatable

-------------------------------------------------
-- HELPERS
-------------------------------------------------

local GM_URL = "api.gameminion.com"
local GM_ACCESS_KEY = ""
local GM_SECRET_KEY = ""
local authToken = ""
local cloudStorageBox = ""

-------------------------------------------------
-- IMPORTS
-------------------------------------------------

local json = require("json")

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------


-- encoding
function b64enc(data)
    -- character table string
	local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

-- decoding
function b64dec(data)
	-- character table string
	local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

local function createBasicAuthHeader(username, password)
	-- header format is "Basic <base64 encoded username:password>"
	local header = "Basic "

	local authDetails = b64enc(username..":"..password)

	header = header..authDetails

	return header
end

local function postGM(path, parameters, networkListener)
	-- POST call to GM
	if (not parameters) then
		parameters = ""
	end

	local params ={}

	params.body = parameters

	local authHeader = createBasicAuthHeader(GM_ACCESS_KEY, GM_SECRET_KEY)

	local headers = {}
	headers["Authorization"] = authHeader

	params.headers = headers

	local url = "http://"..GM_URL

	print("\n----------------")
	print("-- POST Call ---")
	print("Post URL: "..url)
	print("Post Path: "..path)
	print("Post Parameters: "..parameters)
	print("----------------")

	network.request(url.."/"..path, "POST", networkListener, params)
end

local function getGM(path, parameters, networkListener)
	-- GET call to GM
	local params ={}

	--params.body = parameters

	local authHeader = createBasicAuthHeader(GM_ACCESS_KEY, GM_SECRET_KEY)

	local headers = {}
	headers["Authorization"] = authHeader

	params.headers = headers

	local url = "http://"..GM_URL

	print("\n----------------")
	print("-- GET Call ---")
	print("Get URL: "..url)
	print("Get Path: "..path)
	print("Get Parameters: "..parameters)
	print("----------------")

	local hReq = url.."/"..path.."?"..parameters

	print("\nGet Request: "..hReq)
	network.request(hReq, "GET", networkListener, params)
end

local function putGM(path, parameters, putData)
	-- PUT call to GM

	local params = {}


	local authHeader = createBasicAuthHeader(GM_ACCESS_KEY, GM_SECRET_KEY)

	local headers = {}
	headers["Authorization"] = authHeader

	params.headers = headers

	local url = "http://"..GM_URL

	print("\n----------------")
	print("-- PUT Call ---")
	print("Put URL: "..url)
	print("Put Path: "..path)
	print("Put Parameters: "..parameters)
	print("----------------")

	local hReq = url.."/"..path.."?"..parameters

	print("\nPut Request: "..hReq)
	network.request(hReq, "PUT", networkListener, params)
end

local function deleteGM(path, parameters)
	-- Delete call to GM

	local params = {}


	local authHeader = createBasicAuthHeader(GM_ACCESS_KEY, GM_SECRET_KEY)

	local headers = {}
	headers["Authorization"] = authHeader

	params.headers = headers

	local url = "http://"..GM_ACCESS_KEY..":"..GM_SECRET_KEY.."@"..GM_URL

	print("\n----------------")
	print("-- DELETE Call ---")
	print("Delete URL: "..url)
	print("Delete Path: "..path)
	print("Delete Parameters: "..parameters)
	print("----------------")

	local hReq = url.."/"..path.."?"..parameters

	print("\nDelete Request: "..hReq)
	network.request(hReq, "DELETE", networkListener, params)

end


-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

function gameminion.init(accessKey, secretKey)	-- constructor
	-- initialize GM connection

	GM_ACCESS_KEY = accessKey
	GM_SECRET_KEY = secretKey
	
	local newGameminion = {
		authToken = authToken,
		accessKey = GM_ACCESS_KEY,
		secretKey = GM_SECRET_KEY,
		gameID = "0000000000000000000",
		cloudStorageBox = cloudStorageBox,
		gameminion = gameminion
	}
	
	return setmetatable( newGameminion, gameminion_mt )
end

-------------------------------------------------
-- User
-------------------------------------------------

function gameminion:loginWeb()
	local authToken

	return authToken
end

-------------------------------------------------

function gameminion:loginAPI(username, password)
	local params = "login="..username.."&password="..password

	local path = "user_sessions/user_login.json"

	-- set AuthToken when it gets it
	local function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			self.authToken = json.decode(event.response).auth_token
			print("User Logged In!")
			print("Auth Token: "..self.authToken)
			return true
		end
	end

	postGM(path, params, networkListener)

	return true
end

-------------------------------------------------

function gameminion:getMyProfile()
	local params = "auth_token="..self.authToken

	local path = "users/my_profile.json"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("User Profile: "..event.response)
		end
	end

	getGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:registerDevice(deviceToken)
	-- detect current device and populate platform
	local curDevice = system.getInfo("model")
	local platform

	if curDevice == "iPhone" or "iPad" then
		print("Current Device is: "..curDevice)
		platform = "iOS"
	else
		-- Not iOS so much be Android
		print("Current Device is: "..curDevice)
		platform = "Android"
	end

	local params = "auth_token="..self.authToken
	params = params.."&device_id="..deviceToken
	params = params.."&platform="..platform

	local path = "devices.xml"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Device Registered: "..event.response)
		end
	end

	postGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:getUserProfile(userid)
	local params = "auth_token="..self.authToken

	local path = "users/"..userid..".json"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("User "..userid.." Profile: "..event.response)
		end
	end

	getGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:registerUser(firstName, lastName, username, email, password)
	local params = "auth_token="..self.authToken
	params = params.."&username="..username
	params = params.."&first_name="..firstName
	params = params.."&last_name="..lastName
	params = params.."&email="..email
	params = params.."&password="..password

	local path = "users.json"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("User Registered: "..event.response)
		end
	end

	postGM(path, params, networkListener)

end

-------------------------------------------------

function gameminion:recoverPassword(emailAddress)

end

-------------------------------------------------
-- Leaderboards
-------------------------------------------------

function gameminion:getLeaderboards()
	local params = "auth_token="..self.authToken

	local path = "leaderboards.json"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Leaderboards"..event.response)
		end
	end

	getGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:getLeaderboard(leaderboard)
	local params = "auth_token="..self.authToken

	local path = "leaderboards/"..leaderboard..".json"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Leaderboard Details: "..event.response)
		end
	end

	getGM(path, params, networkListener)
end

-------------------------------------------------
function gameminion:submitHighScore(leaderboard, score)
	local params = "auth_token="..self.authToken

	local path = "leaderboards/"..leaderboard.."/scores.json".."?value="..score

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Leaderboard Details: "..event.response)
		end
	end

	postGM(path, params, networkListener)
end

-------------------------------------------------
-- Achievements
-------------------------------------------------

function gameminion:getAchievements()
	local params = "auth_token="..self.authToken

	local path = "achievements.json"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Achievements: "..event.response)
		end
	end

	getGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:getAchievement(achievement)
	local params = "auth_token="..self.authToken

	local path = "achievements/"..achievement..".json"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Achievement: "..event.response)
			return event.response
		end
	end

	getGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:getMyAchievements()
	local params = "auth_token="..self.authToken

	local path = "achievements/user/4ead491c5ceaa10001000015.json"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			local netResponse = {name="netResponse", target=event.response}
			Runtime:dispatchEvent(netResponse)
		end
	end

	getGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:unlockAchievement(achievement, progress)
	local params = "auth_token="..self.authToken

	local path = "achievements/unlock/"..achievement..".json"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Achievement Unlocked: "..event.response)
		end
	end

	postGM(path, params, networkListener)
end

-------------------------------------------------
-- Cloud Storage
-------------------------------------------------

function gameminion:createCloudBox()
	local params = "auth_token="..self.authToken

	local path = "storages.xml"

	-- set cloudStorageBox when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Cloud Storage Box Created: "..event.response)
			--self.cloudStorageBox = json.decode(event.response).auth_token
			self.cloudStorageBox = event.response
		end
	end

	postGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:networkSave(data, storageID)
	local params = "auth_token="..self.authToken

	local path = "storages.xml/"..storageID

	-- set cloudStorageBox when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Cloud Storage Box Updated: "..event.response)
		end
	end

	putGM(path, params, networkListener)

end

-------------------------------------------------

function gameminion:networkLoad(storageID)
	local params = "auth_token="..self.authToken

	local path = "storages.xml/"..storageID

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Cloud Storage: "..event.response)
		end
	end

	getGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:getCloudStorage()
	local params = "auth_token="..self.authToken

	--local path = "storage/"..storageID
	local path = "storages.xml"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Cloud Storage: "..event.response)
		end
	end

	getGM(path, params, networkListener)
end

-------------------------------------------------
-- Analytics
-------------------------------------------------

function gameminion:submitEvent(eventDetails)
	local params = "auth_token="..self.authToken
	params = params.."&event_type="..eventDetails.event_type
	params = params.."&message="..eventDetails.message
	params = params.."&name="..eventDetails.name

	local path = "analytic_events.json"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Analytics Event Submitted: "..event.response)
		end
	end

	postGM(path, params, networkListener)
end

-------------------------------------------------
-- Chat
-------------------------------------------------

function gameminion:createChatRoom(chatRoomName)
	local params = "auth_token="..self.authToken
	params = params.."&name="..chatRoomName

	local path = "chats.xml"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Chat Room Created: "..event.response)
		end
	end

	postGM(path, params, networkListener)

end

-------------------------------------------------


function gameminion:getChatRooms()
	local params = "auth_token="..self.authToken

	local path = "chats.xml"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Chat Rooms: "..event.response)
		end
	end

	getGM(path, params, networkListener)

end

-------------------------------------------------

function gameminion:joinChatRoom(chatroomID)

end

-------------------------------------------------

function gameminion:addUserToChat(userID, chatroomID)

end

-------------------------------------------------

function gameminion:sendChatMessage(chatroomID, message)
	local params = "auth_token="..self.authToken
	params = params.."&chat="..chatroomID

	local path = "chats.xml"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Chat Message Sent: "..event.response)
		end
	end

	postGM(path, params, networkListener)

end

-------------------------------------------------

function gameminion:getChatHistory(chatroomID)
	local params = "auth_token="..self.authToken

	local path = "chats/"..chatroomID..".xml"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Chat Room History: "..event.response)
		end
	end

	getGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:getUsersInChatRoom(chatroomID)
	local params = "auth_token="..self.authToken

	local path = "chats/"..chatroomID.."/members.json"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Chat Room Members: "..event.response)
		end
	end

	getGM(path, params, networkListener)

end

-------------------------------------------------

function gameminion:leaveChatRoom(chatroom)

end

-------------------------------------------------
-- Friends
-------------------------------------------------

function gameminion:getFriends()
	local params = "auth_token="..self.authToken

	local path = "friends.json"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Friends: "..event.response)
		end
	end

	getGM(path, params, networkListener)

end

-------------------------------------------------

function gameminion:addFriend(user)
	local params = "auth_token="..self.authToken
	params = params.."&friend_id="..user

	local path = "friends.json"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Friend Added: "..event.response)
		end
	end

	postGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:removeFriend(user)
	local params = "auth_token="..self.authToken
	params = params.."&friend_id="..user

	local path = "friends.json"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Friend Removed: "..event.response)
		end
	end

	deleteGM(path, params, networkListener)
end

-------------------------------------------------
-- News
-------------------------------------------------

function gameminion:getNews()
	local params = "auth_token="..self.authToken

	local path = "news.json"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("News: "..event.response)
		end
	end

	getGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:getUnreadNews()
	local params = "auth_token="..self.authToken

	local path = "news/unread.json"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("News (Unread): "..event.response)
		end
	end

	getGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:getNewsArticle(article)
	local params = "auth_token="..self.authToken

	local path = "news/"..article..".json"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("News Article: "..event.response)
		end
	end

	getGM(path, params, networkListener)
end

-------------------------------------------------
-- Multiplayer
-------------------------------------------------

function gameminion:createMatch()
	local params = "auth_token="..self.authToken
	
	local path = "games/"..self.gameID.."/matches.xml"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Match Created: "..event.response)
		end
	end

	postGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:getMatches()
	local params = "auth_token="..self.authToken

	local path = "games/"..self.gameID.."/matches.xml"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Get Matches: "..event.response)
		end
	end

	getGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:getMatchDetails(matchID)
	local params = "auth_token="..self.authToken

	local path = "games/"..self.gameID.."/matches/"..matchID..".xml"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Get Match Details: "..event.response)
		end
	end

	getGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:deleteMatch(matchID)

end

-------------------------------------------------

function gameminion:addPlayerToMatch(userID, matchID)
	local params = "auth_token="..self.authToken
	params = params.."&user_id="..userID
	
	local path = "games/"..self.gameID.."/matches/"..matchID.."/add_player.xml"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Player Added to Match: "..event.response)
		end
	end

	postGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:addPlayerToMatchGroup(userID, groupID, matchID)
	local params = "auth_token="..self.authToken
	params = params.."&user_id="..userID
	params = params.."&group_id="..groupID
	
	local path = "games/"..self.gameID.."/matches/"..matchID.."/add_player_to_group.xml"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Player Added to Match Group: "..event.response)
		end
	end

	postGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:removePlayerFromMatch(userID, matchID)

end

-------------------------------------------------

function gameminion:createMatchGroup(groupName, matchID)

end

-------------------------------------------------

function gameminion:deleteMatchGroup(groupID, matchID)

end

-------------------------------------------------

function gameminion:submitMove(moveContent, targetGroup, targetUser, matchID)
	local params = "auth_token="..self.authToken
	params = params.."&content="..moveContent
	
	-- if targetgroup specified then add parameter
	if (targetGroup ~= nil) then
		params = params.."&group_id="..targetGroup
	end
	
	-- if targetUser specified then add parameter
	if (targetGroup ~= nil) then
		params = params.."&target_user_id="..targetUser
	end
	
	local path = "games/"..self.gameID.."/matches/"..matchID.."/move.xml"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Move Submitted: "..event.response)
		end
	end

	postGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:getRecentMoves(matchID)
	local params = "auth_token="..self.authToken

	local path = "games/"..self.gameID.."/matches/"..matchID.."/get_recent_moves.xml"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Recent Match Moves: "..event.response)
		end
	end

	getGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:getAllMoves(matchID)
	local params = "auth_token="..self.authToken
	params = params.."&criteria=all"

	local path = "games/"..self.gameID.."/matches/"..matchID.."/get_recent_moves.xml"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("All Match Moves: "..event.response)
		end
	end

	getGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:startMatch(matchID)
	local params = "auth_token="..self.authToken
	
	local path = "games/"..self.gameID.."/matches/"..matchID.."/start.xml"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Match Started: "..event.response)
		end
	end

	postGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:stopMatch(matchID)
	local params = "auth_token="..self.authToken
	
	local path = "games/"..self.gameID.."/matches/"..matchID.."/stop.xml"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Match Stopped: "..event.response)
		end
	end

	postGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:acceptChallenge(matchID)
	local params = "auth_token="..self.authToken
	
	local path = "games/"..self.gameID.."/matches/"..matchID.."/accept_request.xml"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Challenge Accepted: "..event.response)
		end
	end

	postGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:declineChallenge(matchID)
	local params = "auth_token="..self.authToken
	
	local path = "games/"..self.gameID.."/matches/"..matchID.."/reject_request.xml"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Challenge Declined: "..event.response)
		end
	end

	postGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:createRandomChallenge(matchID)
	local params = "auth_token="..self.authToken
	
	local path = "games/"..self.gameID.."/matches/"..matchID.."/random_match_up.xml"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Random Challenge Sent: "..event.response)
		end
	end

	postGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:createMPChannel(matchID)
	local params = "auth_token="..self.authToken
	
	local path = "games/"..self.gameID.."/matches/"..matchID.."/create_channel_for_player.xml"

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("MP Channel Created: "..event.response)
		end
	end

	postGM(path, params, networkListener)
end

-------------------------------------------------

function gameminion:pollMP(playerID)
	local path = "http://dev-mp-gameminion.herokuapp.com/receive"
	path = path.."?player_id="..playerID

	-- set currentUser when it gets it
	local  function networkListener(event)
		if (event.isError) then
			print("Network Error")
			print("Error: "..event.response)
			return false
		else
			print("Connecting to MP Server: "..event.response)
		end
	end

	network.request(path, "GET", networkListener)
end

-------------------------------------------------

return gameminion