local M = {}

local REQUIRED_METADATA = { "title", "date", "author" }  -- Esempio di campi obbligatori
local METADATA_PATTERN = "^%s*(%w+)%s*:%s*(.+)$"  -- Pattern regex per i metadata
local CREDITS_TAG = "::credits"

local ns = vim.api.nvim_create_namespace("plum_articler_linter")
local linter_enabled = true

-- Funzione per controllare i metadata
local function check_metadata(content, diagnostics)
    local metadata = {}
    local metadata_found = false
    local line_number = 0

    for line in content:gmatch("([^\n]*)\n?") do
        line_number = line_number + 1
        line = line:match("^%s*(.*)%s*$") -- Rimuovi spazi all'inizio e alla fine
        if line == "" then
            break -- Ferma se trovi una riga vuota (fine dei metadata)
        end

        local key, value = line:match(METADATA_PATTERN)
        if key and value then
            key = key:lower()  -- Normalizza la chiave
            if metadata[key] then
                table.insert(diagnostics, {
                    message = "Errore: campo duplicato nei metadata: " .. key,
                    severity = vim.diagnostic.severity.ERROR,
                    lnum = line_number - 1,  -- Usare il numero di riga corretto
                    col = 0,  -- Colonna di inizio (puoi modificarla se necessario)
                })
                return false
            end
            metadata[key] = value
            metadata_found = true
        end
    end

    if not metadata_found then
        table.insert(diagnostics, {
            message = "Errore: non ci sono metadata nel file.",
            severity = vim.diagnostic.severity.ERROR,
            lnum = 0,  -- Posizione predefinita
            col = 0,
        })
        return false
    end

    -- Controlla i campi obbligatori
    for _, req in ipairs(REQUIRED_METADATA) do
        if not metadata[req] then
            table.insert(diagnostics, {
                message = "Errore: mancante il campo obbligatorio nei metadata: " .. req,
                severity = vim.diagnostic.severity.ERROR,
                lnum = 0,  -- Posizione predefinita
                col = 0,
            })
            return false
        end
    end

    return true
end

-- Funzione per controllare la presenza del tag ::credits
local function check_credits(content, diagnostics)
    local line_number = 0

    for line in content:gmatch("([^\n]*)\n?") do
        line_number = line_number + 1
        if line:find(CREDITS_TAG) then
            table.insert(diagnostics, {
                message = "Errore: il tag '::credits' è presente nel file.",
                severity = vim.diagnostic.severity.ERROR,
                lnum = line_number - 1,
                col = 0,  -- Colonna di inizio (puoi modificarla se necessario)
            })
            return false
        end
    end
    return true
end

-- Funzione principale per il linter
function M.lint_markdown(filepath)
    if not linter_enabled then
		return
	end


	local file = io.open(filepath, "r")
    if not file then
        print("Impossibile aprire il file " .. filepath)
        return
    end

    local content = file:read("*all")
    file:close()

    local diagnostics = {}  -- Inizializza la tabella per i messaggi di diagnostica

    local is_metadata_valid = check_metadata(content, diagnostics)
    local is_credits_valid = check_credits(content, diagnostics)

    -- Svuota i messaggi di diagnostica esistenti
    vim.diagnostic.reset(ns)

	local diagnostic_entries = {}
	for _, diag in ipairs(diagnostics) do
		table.insert(diagnostic_entries, {
			message = diag.message,
			severity = diag.severity,
			lnum = tonumber(diag.lnum),
			col = tonumber(diag.col),
		})
	end
	vim.diagnostic.set(ns, 0, diagnostic_entries)
end

return M
