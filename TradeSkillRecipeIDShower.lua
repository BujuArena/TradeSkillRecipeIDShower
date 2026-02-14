-- mainline WoW
if ProfessionsFrame and ProfessionsFrame.CraftingPage and ProfessionsFrame.CraftingPage.SchematicForm then
	local recipeID
	hooksecurefunc(ProfessionsFrame.CraftingPage.SchematicForm, "Init", function(self, recipeInfo, ...)
		if recipeInfo and recipeInfo.recipeID then
			recipeID = tostring(recipeInfo.recipeID)
			self.OutputSubText:SetFontObject("GameFontNormalSmall2")
			if self.RequiredTools:IsShown() then
				self.OutputSubText:SetPoint("TOPLEFT", self.RequiredTools, "BOTTOMLEFT", 0, -3)
			elseif self.RecraftingRequiredTools:IsShown() then
				self.OutputSubText:SetPoint("TOPLEFT", self.RecraftingRequiredTools, "BOTTOMLEFT", 0, -3)
			else 
				self.OutputSubText:SetPoint("TOPLEFT", self.OutputText, "BOTTOMLEFT", 0, -3)
			end
			self.OutputSubText:SetText("Recipe ID: "..HIGHLIGHT_FONT_COLOR_CODE..recipeID..FONT_COLOR_CODE_CLOSE)
			self.OutputSubText:Show()
		else
			recipeID = nil
			if self.OutputSubText then
				self.OutputSubText:SetPoint("TOPLEFT", self.OutputText, "BOTTOMLEFT", 0, -5)
				self.OutputSubText:SetFontObject("GameFontNormal")
			end
		end
	end)
	hooksecurefunc(ProfessionsFrame.CraftingPage.SchematicForm, "SetOutputSubText", function(self, text, ...)
		if recipeID then
			self.OutputSubText:SetText(((text and (text ~= "")) and text.."; " or "").."Recipe ID: "..HIGHLIGHT_FONT_COLOR_CODE..recipeID..FONT_COLOR_CODE_CLOSE)
		end
	end)
end

-- classic WoW
if TradeSkillFrame_SetSelection then
	local function extractRecipeIDFromTradeSkillRecipeLink(linkString)
		return linkString:match("enchant:(%d+)|")
	end

	local recipeLink
	local recipeID
	local tradeSkillRecipeIDFontString = TradeSkillDetailScrollChildFrame:CreateFontString("TradeSkillRecipeIDShowerTradeSkillRecipeIDFontString", "BACKGROUND", "GameFontHighlightSmall")

	hooksecurefunc("SelectTradeSkill", function(selectionID, ...)
		recipeLink = GetTradeSkillRecipeLink(selectionID)
		if recipeLink then
			recipeID = extractRecipeIDFromTradeSkillRecipeLink(recipeLink)
		else
			recipeID = nil
		end
	end)
	
	hooksecurefunc("TradeSkillFrame_SetSelection", function(selectionID, ...)
		if recipeID then
			if TradeSkillDetailScrollChildFrame then
				tradeSkillRecipeIDFontString:SetPoint("TOPLEFT", 	TradeSkillSkillName, "BOTTOMLEFT", 0, 0)
				if TradeSkillRequirementLabel:IsShown() then
					TradeSkillRequirementLabel:SetPoint("TOPLEFT", tradeSkillRecipeIDFontString, "BOTTOMLEFT", 0, 0)
				end
			end
			tradeSkillRecipeIDFontString:SetText("Recipe ID: "..HIGHLIGHT_FONT_COLOR_CODE..recipeID..FONT_COLOR_CODE_CLOSE)
			tradeSkillRecipeIDFontString:Show()
		else
			recipeLink = nil
			tradeSkillRecipeIDFontString:Hide()
		end
	end)
end

-- classic WoW trainer, but couldn't get the recipe ID, so decided to show the item ID if possible at least
if ClassTrainer_SetSelection then
	local itemLink
	local itemID
	local classTrainerItemIDFontString = ClassTrainerDetailScrollChildFrame:CreateFontString("TradeSkillRecipeIDShowerClassTrainerItemIDFontString", "BACKGROUND", "GameFontHighlightSmall")

	hooksecurefunc("SelectTrainerService", function(selectionID, ...)
		itemLink = GetTrainerServiceItemLink(selectionID)
		if itemLink then
			itemID = GetItemInfoFromHyperlink(itemLink)
		else
			itemID = nil
		end
	end)

	hooksecurefunc("ClassTrainer_SetSelection", function(selectionID, ...)
		if itemID then
			if ClassTrainerDetailScrollChildFrame then
				classTrainerItemIDFontString:SetPoint("TOPLEFT", ClassTrainerSkillName, "BOTTOMLEFT", 0, 0)
				if ClassTrainerSkillRequirements:IsShown() then
					ClassTrainerSkillRequirements:SetPoint("TOPLEFT", classTrainerItemIDFontString, "BOTTOMLEFT", 0, 0)
				end
			end
			classTrainerItemIDFontString:SetText("Item ID: "..HIGHLIGHT_FONT_COLOR_CODE..itemID..FONT_COLOR_CODE_CLOSE)
			classTrainerItemIDFontString:Show()
		else
			itemLink = nil
			classTrainerItemIDFontString:Hide()
		end
	end)
end

-- original WoW, from when this addon was first created
if TradeSkillFrame and TradeSkillFrame.DetailsFrame then
	hooksecurefunc(TradeSkillFrame.DetailsFrame, "RefreshDisplay", function(self, ...)
		if self.selectedRecipeID == nil then return end

		local extraText="recipe ID: "..tostring(self.selectedRecipeID)

		local sourceText=self.Contents.SourceText:GetText()
		if sourceText==nil then
			local numReagents = C_TradeSkillUI.GetRecipeNumReagents(self.selectedRecipeID)
			if numReagents > 0 then
				self.Contents.SourceText:SetPoint("TOP", self.Contents.Reagents[numReagents], "BOTTOM", 0, -15)
			else
				self.Contents.SourceText:SetPoint("TOP", self.Contents.ReagentLabel, "TOP");
			end
			sourceText=extraText
			self:AddContentWidget(self.Contents.SourceText)
			self.Contents.SourceText:Show()
		else
			sourceText=sourceText.."\n\n"..extraText
		end
		self.Contents.SourceText:SetText(sourceText)
		self:RefreshButtons()
	end)
end