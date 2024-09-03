local M = {}


local REPO_NAME = 'test-articles'
local REPO_URL = 'https://github.com/plum-juice-project/test-articles.git'
local ARTICLE_PATH = 'content/articles'
local REPO_BRANCH = 'main'
local ORG_NAME = 'plum-juice-project'

local function get_username()
	local handle = io.popen('gh auth status')
	if not handle then
		print("Impossibile to execute 'gh auth status'\n Be sure to have gh-cli installed.")
		return false
	end
	local result = handle:read("*a")

	handle:close()

	return result:match("Logged in to (.*) as")
end

function M.is_authenticated()
    -- Esegui il comando `gh auth status` e controlla l'output
    local handle = io.popen('gh auth status')
	if not handle then
		print("Impossibile to execute 'gh auth status'\n Be sure to have gh-cli installed.")
		return false
	end
	local result = handle:read("*a")

	handle:close()

    if result:match("Logged in to") then
        return true
    else
        return false
    end
end

function M.authenticate()
    if not M.is_authenticated() then
        vim.cmd('!gh auth login')

        if M.is_authenticated() then
            print("Succesfully authenticated to GitHub.")
        else
            print("Failed to authenticate to GitHub.")
        end
    else
        print("Already authenticated!")
    end
end

function M.push_article(filepath)
    if not M.is_authenticated() then
        M.authenticate()
    end

    if M.is_authenticated() then
		local file = io.open(filepath, "rb")
		if not file then
			print("Impossible to open the file " .. filepath)
			return
		end

		local filename = vim.fn.fnamemodify(filepath, ":t")

		local content = file:read("*all")
		file:close()

		local content_base64 = vim.fn.system("echo -n '" .. content .. "' | base64")

		--/repos/${ORG_NAME}/${REPO_NAME}/contents/${ARTICLE_PATH}/${fileName}
		local api_path = string.format('/repos/%s/%s/contents/%s/%s', ORG_NAME, REPO_NAME, ARTICLE_PATH, filename)

		local message = string.format("Add article %s by %s", filename, get_username()) 
		local cmd = string.format(
			"gh api %s -X PUT -f message='Add article' -f content='%s' -f branch='%s'",
			message,
			api_path,
			content_base64,
			REPO_BRANCH
		)

		vim.fn.system(cmd)

        print("File caricato con successo!")
    else
        print("Non autenticato. Impossibile caricare l'articolo.")
    end 
end
return M
