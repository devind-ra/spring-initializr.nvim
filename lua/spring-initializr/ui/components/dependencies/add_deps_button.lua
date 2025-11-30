---------------------------------------------------------------------------
--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
--
-- spring-initializr.nvim
--
--
-- Copyright (C) 2025 Josip Keresman
--
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
----------------------------------------------------------------------------

----------------------------------------------------------------------------
--
-- Manages the Dependency button functions related to Spring Initializr 
-- dependency selection working with dependencies displaying and card.
--
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- Dependencies
----------------------------------------------------------------------------
local Popup = require("nui.popup")

local buffer_manager = require("spring-initializr.ui.managers.buffer_manager")
local focus_manager = require("spring-initializr.ui.managers.focus_manager")
local message_utils = require("spring-initializr.utils.message_utils")
local picker = require("spring-initializr.telescope.telescope")
local dependency_card = require("spring-initializr.ui.components.dependencies.dependency_card")
local icons = require("spring-initializr.ui.icons.icons")

----------------------------------------------------------------------------
-- Module
----------------------------------------------------------------------------
local M = {
    state = { dependencies_panel = nil },
}

----------------------------------------------------------------------------
-- Constants
----------------------------------------------------------------------------
local BUTTON_SIZE = { height = 3, width = 40 }
local BUTTON_TITLE = "Add Dependencies (Telescope)"

----------------------------------------------------------------------------
--
-- Returns the border configuration for the "Add Dependencies" button.
--
-- @return table  Border configuration table
--
----------------------------------------------------------------------------
local function button_border()
    local formatted_title = icons.format_section_title(BUTTON_TITLE)
    return { style = "rounded", text = { top = formatted_title, top_align = "center" } }
end

----------------------------------------------------------------------------
--
-- Returns the window options for the "Add Dependencies" button.
--
-- @return table  Window options
--
----------------------------------------------------------------------------
local function button_win_options()
    return { winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder" }
end

----------------------------------------------------------------------------
--
-- Returns the buffer options for the "Add Dependencies" button.
-- Makes the button readonly to prevent text editing.
--
-- @return table  Buffer options
--
----------------------------------------------------------------------------
local function button_buffer_options()
    return {
        modifiable = false,
        readonly = true,
    }
end

----------------------------------------------------------------------------
--
-- Builds the configuration table for the dependencies button popup.
--
-- @return table  Popup configuration
--
----------------------------------------------------------------------------
local function button_popup_config()
    return {
        border = button_border(),
        size = BUTTON_SIZE,
        enter = true,
        buf_options = button_buffer_options(),
        win_options = button_win_options(),
    }
end

----------------------------------------------------------------------------
--
-- Bind the <CR> key on the button popup to open the picker and refresh.
--
-- @param popup      Popup     NUI popup instance for the button
-- @param on_update  function  Callback to refresh the dependencies list
--
----------------------------------------------------------------------------
local function bind_button_action(popup, on_update)
    popup:map("n", "<CR>", function()
        open_picker_and_refresh(on_update)
    end, { noremap = true, nowait = true })
end

----------------------------------------------------------------------------
--
-- Create a popup button that triggers dependency selection.
--
-- @param update_display_fn  function  Callback to update the dependency display
--
-- @return Layout.Box  The button wrapped in a Layout.Box
--
----------------------------------------------------------------------------
function M.create_button(update_display_fn)
    local popup = Popup(button_popup_config())
    bind_button_action(popup, update_display_fn)
    register_focus_for_components(popup)
    return popup
end

----------------------------------------------------------------------------
-- Exports
----------------------------------------------------------------------------
return M
