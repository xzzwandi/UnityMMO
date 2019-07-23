local GoodsInfoView = BaseClass(UINode)

function GoodsInfoView:Constructor( )
	self.viewCfg = {
		prefabPath = ResPath.GetFullUIPath("common/GoodsInfoView.prefab"),
		canvasName = "Normal",
		components = {
			{UI.Background, {is_click_to_close=true, alpha=0.5}},
		},
	}
	self.model = BagModel:GetInstance()
	self:Load()
end

function GoodsInfoView.Create(  )
	return LuaPool:Get("GoodsInfoView")
end

function GoodsInfoView:OnLoad(  )
	local names = {
		"layout/info_con/desc_scroll/Viewport/desc_con/overdue:txt","layout/info_con/desc_scroll/Viewport/desc_con/desc:txt","layout/info_con/head_con/name:txt","layout/info_con/head_con/icon_con","layout/info_con/head_con/num:txt","layout/info_con/head_con/level:txt","layout","layout/info_con/desc_scroll/Viewport/desc_con/use_desc:txt","layout/get_way_con:obj","layout/info_con","layout/info_con/head_con",
		
	}
	UI.GetChildren(self, self.transform, names)

	local btnsName = {
		"layout/btns_con/drop_btn:obj","layout/btns_con/use_btn:obj","layout/btns_con/sell_btn:obj","layout/btns_con/buy_btn:obj","layout/btns_con/store_btn:obj",
	}
	self.btns = {}
	UI.GetChildren(self.btns, self.transform, btnsName)

	self.overdue_txt.text = ""
end

function GoodsInfoView:AddEvents( )
	local on_click = function ( click_obj )
		if self.btns.drop_btn_obj == click_obj then
			local on_ack = function ( ackData )
		        print("Cat:GoodsInfoView [start:29] ackData: ", ackData)
		        PrintTable(ackData)
		        print("Cat:GoodsInfoView [end]")
		        if ackData.result == ErrorCode.Succeed then
		        	Message:Show("销毁成功")
		        	self:Destroy()
		        end
		    end
		    NetDispatcher:SendMessage("Bag_DropGoods", {uid=uid}, on_ack)
		elseif self.btns.store_btn_obj == click_obj then
		elseif self.btns.buy_btn_obj == click_obj then
		elseif self.btns.sell_btn_obj == click_obj then
		elseif self.btns.use_btn_obj == click_obj then
			
		end
	end
	UI.BindClickEvent(self.btns.use_btn_obj, on_click)
	UI.BindClickEvent(self.btns.sell_btn_obj, on_click)
	UI.BindClickEvent(self.btns.buy_btn_obj, on_click)
	UI.BindClickEvent(self.btns.store_btn_obj, on_click)
	UI.BindClickEvent(self.btns.drop_btn_obj, on_click)
	
end

--[[showData可配置字段：
comeFrom:一个字符串，指定来自哪里点开的
isShowGetWay:是否显示获取途径
btnList:显示的按钮列表
--]]
function GoodsInfoView:SetData( goodsInfo, showData )
	self.goodsInfo = goodsInfo
	self.showData = showData
	if self.isLoaded then
		self:OnUpdate()
	else
		self.isNeedUpdateOnLoad = true
	end
end

function GoodsInfoView:UpdateBtns()
	for k,v in pairs(self.btns) do
		v.gameObject:SetActive(false)
	end
	if self.showData and self.showData.comeFrom then
		if self.showData.comeFrom == "BagView" then
			self.showData.btnList = self.showData.btnList or {}
			table.insert(self.showData.btnList, "drop_btn")
			table.insert(self.showData.btnList, "store_btn")
		end
	end
	print("Cat:GoodsInfoView [start:83] self.showData.b", self.showData)
	PrintTable(self.showData.btnList)
	print("Cat:GoodsInfoView [end]")
	if self.showData and self.showData.btnList then
		for i,v in ipairs(self.showData.btnList) do
			self.btns[v.."_obj"]:SetActive(true)
		end
	end
end

function GoodsInfoView:OnUpdate(  )
	if not self.isLoaded then return end
	
	self:UpdateInfo()
	self:UpdateBtns()
	self:UpdateGetWay()
end

function GoodsInfoView:UpdateGetWay(  )
	local isShow = self.showData and self.showData.isShowGetWay
	self.get_way_con_obj:SetActive(isShow)
	if isShow then
		--Cat_Todo : add get way view
	end
end

function GoodsInfoView:UpdateInfo(  )
	self.name_txt.text = self.model:GetGoodsName(self.goodsInfo.typeID, true)
end

function GoodsInfoView:Recycle(  )
	LuaPool:Recycle("GoodsInfoView", self)
end

function GoodsInfoView:Destroy(  )
	print('Cat:GoodsInfoView.lua[Destroy]')
	self:Recycle()
end

return GoodsInfoView