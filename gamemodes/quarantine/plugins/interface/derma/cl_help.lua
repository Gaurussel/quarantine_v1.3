
local backgroundColor = Color(0, 0, 0, 66)
local PANEL = {}

AccessorFunc(PANEL, "maxWidth", "MaxWidth", FORCE_NUMBER)

function PANEL:Init()
	self:SetWide(180)
	self:Dock(LEFT)

	self.maxWidth = ScrW() * 0.2
end

function PANEL:Paint(width, height)
end

function PANEL:SizeToContents()
	local width = 0

	for _, v in ipairs(self:GetChildren()) do
		width = math.max(width, v:GetWide())
	end

	self:SetSize(math.max(32, math.min(width, self.maxWidth)), self:GetParent():GetTall())
end


vgui.Register("ixHelpMenuCategories", PANEL, "EditablePanel")

-- help menu
PANEL = {}

function PANEL:Init()
	self:SetWide(ScrW())
	self:SetTall(ScrH() * 0.95)

	self.categories = {}
	self.categorySubpanels = {}
	self.buttonList = {}

	self.categoryPanel = self:Add("Panel")
	self.categoryPanel:Dock(TOP)
	self.categoryPanel:DockMargin(2, 2, 2, 2)
	--self.categoryPanel:DockMargin(15, 15, 15, 15)
	self.categoryPanel:SetTall(50)
	self.categoryPanel.Paint = function(this, width, height)
		surface.SetDrawColor(30, 30, 30, 230)
		surface.DrawRect(0, 0, width, height)
	end

	self.canvasPanel = self:Add("EditablePanel")
	self.canvasPanel:Dock(FILL)

	self.idlePanel = self.canvasPanel:Add("Panel")
	self.idlePanel:Dock(FILL)
	self.idlePanel:DockMargin(8, 0, 0, 0)
	self.idlePanel.Paint = function(_, width, height)
		--[[surface.SetDrawColor(backgroundColor)
		surface.DrawRect(0, 0, width, height)]]

		derma.SkinFunc("DrawHelixCurved", width * 0.5, height * 0.5, width * 0.25)

		surface.SetFont("ixIntroSubtitleFont")
		local text = L("helix"):lower()
		local textWidth, textHeight = surface.GetTextSize(text)

		surface.SetTextColor(color_white)
		surface.SetTextPos(width * 0.5 - textWidth * 0.5, height * 0.5 - textHeight * 0.75)
		surface.DrawText(text)

		surface.SetFont("ixMediumLightFont")
		text = L("helpIdle")
		local infoWidth, _ = surface.GetTextSize(text)

		surface.SetTextColor(color_white)
		surface.SetTextPos(width * 0.5 - infoWidth * 0.5, height * 0.5 + textHeight * 0.25)
		surface.DrawText(text)
	end

	local categories = {}
	hook.Run("PopulateHelpMenu", categories)

	for k, v in SortedPairs(categories) do
		if (!isstring(k)) then
			ErrorNoHalt("expected string for help menu key\n")
			continue
		elseif (!isfunction(v)) then
			ErrorNoHalt(string.format("expected function for help menu entry '%s'\n", k))
			continue
		end

		self:AddCategory(k)
		self.categories[k] = v
	end

	if (ix.gui.lastHelpMenuTab) then
		self:OnCategorySelected(ix.gui.lastHelpMenuTab)
	end
end

function PANEL:AddCategory(name)
	local button = self.categoryPanel:Add("qHelpMenuButton")
	button:SetText(L(name))
	-- @todo don't hardcode this but it's the only panel that needs docking at the bottom so it'll do for now
	button:SizeToContents()
	button:Dock(LEFT)
	button.DoClick = function(this)
		self:OnCategorySelected(name, this)
	end


	for k, v in pairs(self.categoryPanel:GetChildren()) do
		v:SetWide(self:GetWide() / #self.categoryPanel:GetChildren())
	end

	local panel = self.canvasPanel:Add("DScrollPanel")
	panel:SetVisible(false)
	panel:Dock(FILL)
	panel:DockMargin(8, 15, 0, 15)
	panel:GetCanvas():DockPadding(8, 8, 8, 8)

	panel.Paint = function(_, width, height)
		--[[surface.SetDrawColor(backgroundColor)
		surface.DrawRect(0, 0, width, height)]]
	end

	-- reverts functionality back to a standard panel in the case that a category will manage its own scrolling
	panel.DisableScrolling = function()
		panel:GetCanvas():SetVisible(false)
		panel:GetVBar():SetVisible(false)
		panel.OnChildAdded = function() end
	end

	self.categorySubpanels[name] = panel
	self.buttonList[name] = button
	panel:SizeToContents()
end

function PANEL:Paint(width, height)
	local configColor = ix.config.Get("color")

	surface.SetDrawColor(configColor.r, configColor.g, configColor.b)
	surface.DrawOutlinedRect( 0, 0, width, height, 1 )
end

function PANEL:OnCategorySelected(name)
	local panel = self.categorySubpanels[name]

	if ix.gui.lastHelpMenuTab then
		self.buttonList[ix.gui.lastHelpMenuTab].selected = false
	end
	self.buttonList[name].selected = true
	

	if (!IsValid(panel)) then
		return
	end

	if (!panel.bPopulated) then
		self.categories[name](panel)
		panel.bPopulated = true
	end

	if (IsValid(self.activeCategory)) then
		self.activeCategory:SetVisible(false)
	end

	panel:SetVisible(true)
	self.idlePanel:SetVisible(false)

	self.activeCategory = panel
	ix.gui.lastHelpMenuTab = name
end

vgui.Register("ixHelpMenu", PANEL, "EditablePanel")

local function DrawHelix(width, height, color) -- luacheck: ignore 211
	local segments = 76
	local radius = math.min(width, height) * 0.375

	surface.SetTexture(-1)

	for i = 1, math.ceil(segments) do
		local angle = math.rad((i / segments) * -360)
		local x = width * 0.5 + math.sin(angle + math.pi * 2) * radius
		local y = height * 0.5 + math.cos(angle + math.pi * 2) * radius
		local barOffset = math.sin(SysTime() + i * 0.5)
		local barHeight = barOffset * radius * 0.25

		if (barOffset > 0) then
			surface.SetDrawColor(color)
		else
			surface.SetDrawColor(color.r * 0.5, color.g * 0.5, color.b * 0.5, color.a)
		end

		surface.DrawTexturedRectRotated(x, y, 4, barHeight, math.deg(angle))
	end
end

hook.Add("CreateMenuButtons", "ixHelpMenu", function(tabs)
	tabs["help"] = function(container)
		container:Add("ixHelpMenu")
	end
end)

local textLore = {
	[1] = {
		title = "Зона карантина",
		onetext = "1.12.19 – Начало пандемии неизвестного вируса, класс VII, содержащий двуцепочечную ДНК, реплицирующиеся через стадию одноцепочечной РНК. Симптомы – головная боль, кашель, потеря зрения, учащенное дыхание, нехватка кислорода, онемение конечностей. Распространение – Воздушно-капельным путем.",
	},
	[2] = {
		title = "15.12.19",
		onetext = "Государства мира начали активную защиту от пандемии, не забывая разрабатывать вакцину, пока все люди мира наблюдали за развитием глобальной ошибки человечества. Некоторые и не понимали настоящей проблемы мира – слабый иммунитет каждого третьего в мире, передача вируса через обычный кашель любого ребенка, общественный транспорт, перелеты из страны в страну.",
	},
	[3] = {
		title = "25.12.19",
		onetext = "США, Эмбаррасс, Миннесота. Средняя температура в городе -5,6. На окраине города находилась в активной разработке база, строительство которого было заморожено в 2013 году по приказу главнокомандующего Армии США. Из-за активного распространения вируса, база снова начала обретать красоты военных сооружений – боеголовки, боевые машины, вертолетная площадка, станковые пулеметы, кирпичные стены высотой в 5-6 метров, колючая проволока. Но площадью она не привлекала. Через-чур тесно для более тысячи солдат.",
		twotext = "Местные жители города не особо были рады постройке данной базы - шум, стрельба, военный транспорт… вечно проезжающий по субботам в городе. [Комментарий корреспондента местного канала: ‘Эти гигантские машины очень сильно шумят и портят воздух нашего прекрасного городка! Невыносимо слышать в субботнее утро колонну этих очень… До ужаса громкий шум больших колес! Вы представляете, если они захотят проехать на танке? Да вы с ума сойдете! Куда идут наши налоги!? После них асфальт стал... – не пройти и не проехать!’]. Конечно же, государство пропустило это мимо ушей, так-как важной задачей учитывалось сохранение боевого потенциала. Но люди нашли огромный плюс - преступность снизилась, но не все бандитские группировки покинули пределы города, массовые мероприятия Армии США показали высокую эффективность.",
	},
	[4] = {
		title = "8.03.20",
		onetext = "Вирус набирал колоссальные обороты. Почти все страны мира были заражены на 1.2 часть населения. США одна из первых, по началу которая, предприняла меры с использованием убежищ и закрытие всех доступов посещения страны. Тотальный карантин – закрытие половины городов на выезд и въезд, транспортировка войск Армии США на территорию городов и активное участие в контроле проездных пунктов. Покидание своих домов запрещено, поход за продуктами только по расписанию для каждой из семей.",
	},
	[5] = {
		title = "12.01.21",
		onetext = "Прошел почти год от Тотального карантина, измены потерпел лишь вирус. С каждым зараженным, симптомы становились хуже, вплоть до смертельности. Министерство обороны и здравоохранения предпринимают жестокие меры к жителям населенных пунктов. Детей, жен, мужей – силой забирают на оккупированные базы Армии. Лишь те, кому удалось скрыться или сбежать из лап военных, не попали в этот ад.",
		twotext = "Комментарий из интернета местного жителя [1,7 тысяч лайков; 855,329 тысячи просмотров] – ‘Уважаемые, вы понимаете, что сейчас происходит? Да вы вообще ничего не понимаете! Эти мамины сынки забирают наших детей, жен неизвестно куда и зачем! Они дают вам бумаги на подпись принудительно, никогда не подписывайте их, терпите всю боль, которую вам нанесут, не беритесь за шариковую ручку! … А что, если они забирают их на опыты и отдают обратно, если выжил? А тех, кто умер… пишут на оборванном листке «про ухудшения здоровья в связи с вирусом»? Это ужасно до боли, но никто пока не предоставил факт убийств.’",
	},
	[6] = {
		title = "29.02.21",
		onetext = "Царила безработица. Люди перестали работать ради безрассудной валютной единицы. Обесценивание денег, грабеж, убийства, воровство – все это наталкивало людей на массовый бунт вперерез властей города. Мятежи вовсе не заканчивались, своего рода требования смены власти из-за критической ситуации в виде «вируса». Народ требовал отпустить своих родственников из плена, а со стороны Армии лишь тишина и игнорирование требований.",
	},
	[7] = {
		title = "10.03.21",
		onetext = "Революция… Люди не выдержали поголовное издевательство близких, массовое скупка вооружения по всему городу, специальное оборудование для ковки гильз и припасов. Многие начали собирать группировки для штурма базы, тем самым, заставить власть хоть как-то одуматься и пойти на встречу людям.",
	},
	[8] = {
		title = "Ночь с 10.03.21 на 11.03.21…",
		onetext = "Затишье, слышен только лай собак и ветер, скользящий вдоль зданий. В эту ночь, по слухам, должен проехать конвой с военными и учеными. На другом конце города, сослуживцы ожидали передачи ценных бумаг, в обмен на пропитание и новую защитную форму.",
		twotext = "[Месяц назад: Государство написало требование к ученым – «За каждое продвижение вакцины - безвредной реализации, не имея побочных эффектов, вам будет выдано поощрение в виде: пропитания, защитной одежды. Это абсолютно за счет государства и его структур.»]",
		threetext = "Жители, состоящие в группировках, которые уже можно назвать «Банды», готовились к этой перевозке, но… Нападать решили с хитростью – при перевозке груза, на обратный путь к базе.",
		fourtext = "Груз тронулся с места сделки и направился в сторону базы, на пути котором, люди, жаждущие мести, заняли контратакующие позиции. Завязалась перестрелка, глобальная и первая в истории этого города… Стрельба длилась на протяжении 4-ех часов, по концу которой, Армия США с успехом вернулись на базу, убив меньше сотни людей. Город понял, что это более чем близость на тоталитаризм и огромный террор людей.",
	},
	[9] = {
		title = "10.04.2021",
		onetext = "В это время нет богатств в виде денег или же золота. Теперь ценятся: продукты питания, оружие, ящики с патронами, одежда. Звериные поступки считаются нормой. Грабежи, изнасилование, издевательство? Не смешите, теперь это повседневное хобби.",
		twotext = "Война не прекращалась. Каждый, кто хотел сбежать из города, был убит на месте, без каких-либо предупреждений… Проникновение на базу – расстрел, попытка убийства военного или сопротивления – расстрел. Пощады со стороны Армии США не было и не будет, как и их принципов. Настоящее выживание. Люди терзали друг друга, ради своей выгоды. Основывались группировки, подготавливаемые для штурма военной базы. ",
		threetext = "Город отделился от базы военных. Ни военные, ни банды – не хотели соваться в чужие дела.",
		fourtext = "Ученые смогли создать первый прототип вакцины, которая лишь понижает стадию заражения и последствий, не давая умереть человеку. Но тут вопрос, как ее раздобыть обычным гражданам? – обобрать до нитки военный конвой или найти в заброшенной лаборатории.",
	},
	[10] = {
		title = "Информация для внутриигрового геймплея",
		onetext = "Ваша жизнь, в ваших руках. Полная свобода действий – станьте ученым, защищайте базу за военного, грабьте или убивайте ради своей выгоды за выжившего, организовывайтесь в группы и нападайте со всех сил на базу военных за бандита. Придерживайтесь своих инстинктов, делайте то, что нужно для вашего персонажа. Дружелюбие – нет… нет-нет-нет! Повезет, если вы найдете себе напарника.",
		twotext = "Навыки. Данная разработка дает вам возможность прокачаться в одном из направлений, будь то шеф-повар или же искатель. Каждый навык описан в меню, но не забудьте прочитать описание, прежде чем тратить скилл-поинт.",
		threetext = "На сервере и его карте доступны так называемые «КвестоМан’ы», своего рода NPC, возможности которого, дать вам задание, для более сгущенного геймплея и… трепета ваших нервов. Цели, выданные ими, могут быть абсолютно разные, начиная с поиска какого-либо предмета, заканчивая проникновением на базу или даже убийством.",
		fourtext = "Так же постройка. На сервере запрещены инструменты используемые в SandBox. Построить вы можете благодаря нашему функционалу. Вам потребуется лишь материал, для постройки вашего сооружения.",
		fivetext = "И многое-многое другое!",
	},
}

local textRule = {
	[1] = {
		title = "Законы штата Миннесота",
		onetext = "Мы, народ Соединенных Штатов Америки города Миннесота, придерживаемся законов, с целью образовать и установить правосудие, гарантировать внутреннее спокойствие, обеспечить совместную оборону, содействовать всеобщему благоденствию и закрепить блага свободы за нами и потомством нашим провозглашаем и устанавливаем настоящее законодательство для города Миннесота.",
	},
	[2] = {
		title = "Закон №1",
		onetext = "Умышленное убийство, кровная расплата, совершенным в единственном лице или же в составе устойчивой группой лиц, заранее объединившихся. В случае нарушения закона, предусматривается лишение свободы от 3-ех до 10 лет.",
		twotext = "Предписание\n Если лицо или же группа лиц, имеют полную одержимость и неподчинение властям города – наказание выносится на месте, т.е. смертельный исход.",
	},
	[3] = {
		title = "Закон №2",
		onetext = "Умышленное причинение тяжкого, среднего, легкого вреда здоровья лицу или же группы лиц. В случае нарушения закона, предусматривается лишение свободы от полугода до 2-ух лет.",
		twotext = "Предписание \nА). В особо тяжком умышленном нанесении вреда, влечет за собой максимальный срок.\nБ). Если лицо или же группа лиц, имеют полную одержимость и не подчинение властям города – наказание выносится в соответствии с предписанием закона №1.",
	},
	[4] = {
		title = "Закон №3",
		onetext = "Воровство, грабеж, умышленное и незаконное присвоение чужого имущества. В случае нарушения закона, предусматривается лишение свободы от 2-ух месяцев до 1 года.",
	},
	[5] = {
		title = "Закон №4",
		onetext = "Умышленное уничтожение чужого имущества, издевательства и насильственное применение поджигающих, осколочных и т.п. вещей. В случае нарушения закона, предусматривается лишением свободы от полугода до 3-ех лет.",
	},
	[6] = {
		title = "Закон №5",
		onetext = "Запрещено препятствовать службе военным лицам или лицам, находящимся под контролем военных лиц. В случае нарушения закона, предусматриваются исправительные работы сроком от 1-го дня до 1-го месяца.",
	},
	[7] = {
		title = "Закон №6",
		onetext = "Запрещено проведения собраний, митингов и демонстраций, шествий и пикетирования, а также иных массовых мероприятий. В случае нарушения закона, предусматриваются исправительные работы сроком от 6-и до 10-и месяцев.",
	},
	[8] = {
		title = "Закон №7",
		onetext = "Запрещена продажа оружия, боеприпасов, взрывчатых и ядовитых веществ, установление особого режима оборота лекарственных средств и препаратов, содержащих наркотические и иные сильнодействующие вещества. В случае нарушения закона, предусматривается изъятие и лишение свободы от 3-ех до 8-и лет.",
		twotext = "Предписание\nА). Если лицо или группа лиц злоупотребляли запрещенной торговлей или же использовали в злостных намереньях – высшая мера наказания, включая пожизненное лишение свободы\nБ) Если лицо или группа лиц неумышленно использовали, перемещали, обменивались – наказание выносится устно, включая изъятие предметов.",
	},
	[9] = {
		title = "Закон №8",
		onetext = "Каждое лицо, проживающие, обитающее находящее на территории города обязан подчиняться любому из органов исполнительной власти и органы военного управления. В случае нарушения закона, предусматриваются исправительные работы сроком от 2-ух недель.",
		twotext = "Предписание\nА). Выполнять требования органов исполнительной власти и их должностных лиц. Оказывать содействие органам и лицам.\nБ). Являться по вызову в органы исполнительной власти, органы военного управления.\nВ). Выполнять требования, изложенные в полученных ими предписаниях, распоряжениях органов исполнительной власти, органов военного управления, и их должностных лиц.\nГ). Участвовать в порядке, установленном Правительством, в выполнении работ для нужд обороны, ликвидации последствий, восстановлении поврежденных (разрушенных) объектов города, военных объектов.",
	},
	[10] = {
		title = "Закон №9",
		onetext = "Запрещено посещение запретных, огнеопасных, зараженных, токсичных территорий лицам, не относящимся к органам власти, органам военного управления, должностным лицам. В случае нарушение закона, предусматривается условное предупреждение, исправительные работы, лишение свободы сроком от 3-ех дней.",
	},
	[11] = {
		title = "Закон №10",
		onetext = "Закон гласит запреты и обязательства при посещении территории военного управления, исполнительной власти, должностных лиц. В случае нарушения закона, предусматривается высшая мера наказания – лишение свободы от 10-и лет вплоть до смертельного исхода.\nА). Запрещается вести себя неподобающе, неадекватно, проявлять опасность окружающим. \nБ). В обязательном порядке соблюдать этикет, адекватную речь, мимику лица.\nВ). Запрещается проносить с собой: \n1. Огнеопасные предметы. \n2. Взрывчатые, осколочные.\n3. Огнестрельное оружие любого калибра.\n4. Холодное оружие, в том числе заточки.\n5. Любой вид отравляющих, токсичных, радиоактивных веществ. \n6. Любой вид приемо-передающих предметов (Рация, сотовые и т.п.). \nГ). Запрещен бег, свободная прогулка, громкие разговоры, стоны, крики, цензурная брань.\nД). Порча имущества на территории, в том числе любая техника - движимая или недвижимая.",
	}
}

hook.Add("PopulateHelpMenu", "ixHelpMenu", function(tabs)
	tabs["settings"] = function(container)
			local panel2 = container:Add("DPanel")
			panel2:SetTall(ScrH() * 0.9)
			panel2:SetWide(ScrW())

			local panel = panel2:Add("ixSettings")
			panel:SetSearchEnabled(true)

			for category, options in SortedPairs(ix.option.GetAllByCategories(true)) do
				category = L(category)
				panel:AddCategory(category)

				-- sort options by language phrase rather than the key
				table.sort(options, function(a, b)
					return L(a.phrase) < L(b.phrase)
				end)

				for _, data in pairs(options) do
					local key = data.key
					local row = panel:AddRow(data.type, category)
					local value = ix.util.SanitizeType(data.type, ix.option.Get(key))

					row:SetText(L(data.phrase))
					row:Populate(key, data)

					-- type-specific properties
					if (data.type == ix.type.number) then
						row:SetMin(data.min or 0)
						row:SetMax(data.max or 10)
						row:SetDecimals(data.decimals or 0)
					end

					row:SetValue(value, true)
					row:SetShowReset(value != data.default, key, data.default)
					row.OnValueChanged = function()
						local newValue = row:GetValue()

						row:SetShowReset(newValue != data.default, key, data.default)
						ix.option.Set(key, newValue)
					end

					row.OnResetClicked = function()
						row:SetShowReset(false)
						row:SetValue(data.default, true)

						ix.option.Set(key, data.default)
					end

					row:GetLabel():SetHelixTooltip(function(tooltip)
						local title = tooltip:AddRow("name")
						title:SetImportant()
						title:SetText(key)
						title:SizeToContents()
						title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))

						local description = tooltip:AddRow("description")
						description:SetText(L(data.description))
						description:SizeToContents()
					end)
				end
			end

			container.panel = panel
			container.panel.searchEntry:RequestFocus()
		end

		tabs["commands"] = function(container)
		-- info text
		local info = container:Add("DLabel")
		info:SetFont("ixSmallFont")
		info:SetText(L("helpCommands"))
		info:SetContentAlignment(5)
		info:SetTextColor(color_white)
		info:SetExpensiveShadow(1, color_black)
		info:Dock(TOP)
		info:DockMargin(0, 0, 0, 8)
		info:SizeToContents()
		info:SetTall(info:GetTall() + 16)

		info.Paint = function(_, width, height)
			surface.SetDrawColor(ColorAlpha(derma.GetColor("Info", info), 160))
			surface.DrawRect(0, 0, width, height)
		end

		-- commands
		for uniqueID, command in SortedPairs(ix.command.list) do
			if (command.OnCheckAccess and !command:OnCheckAccess(LocalPlayer())) then
				continue
			end

			local bIsAlias = false
			local aliasText = ""

			-- we want to show aliases in the same entry for better readability
			if (command.alias) then
				local alias = istable(command.alias) and command.alias or {command.alias}

				for _, v in ipairs(alias) do
					if (v:lower() == uniqueID) then
						bIsAlias = true
						break
					end

					aliasText = aliasText .. ", /" .. v
				end

				if (bIsAlias) then
					continue
				end
			end

			-- command name
			local title = container:Add("DLabel")
			title:SetFont("ixMediumLightFont")
			title:SetText("/" .. command.name .. aliasText)
			title:Dock(TOP)
			title:SetTextColor(ix.config.Get("color"))
			title:SetExpensiveShadow(1, color_black)
			title:SizeToContents()

			-- syntax
			local syntaxText = command.syntax
			local syntax

			if (syntaxText != "" and syntaxText != "[none]") then
				syntax = container:Add("DLabel")
				syntax:SetFont("ixMediumLightFont")
				syntax:SetText(syntaxText)
				syntax:Dock(TOP)
				syntax:SetTextColor(color_white)
				syntax:SetExpensiveShadow(1, color_black)
				syntax:SetWrap(true)
				syntax:SetAutoStretchVertical(true)
				syntax:SizeToContents()
			end

			-- description
			local descriptionText = command:GetDescription()

			if (descriptionText != "") then
				local description = container:Add("DLabel")
				description:SetFont("ixSmallFont")
				description:SetText(descriptionText)
				description:Dock(TOP)
				description:SetTextColor(color_white)
				description:SetExpensiveShadow(1, color_black)
				description:SetWrap(true)
				description:SetAutoStretchVertical(true)
				description:SizeToContents()
				description:DockMargin(0, 0, 0, 8)
			elseif (syntax) then
				syntax:DockMargin(0, 0, 0, 8)
			else
				title:DockMargin(0, 0, 0, 8)
			end
		end
	end

	tabs["flags"] = function(container)
		-- info text
		local info = container:Add("DLabel")
		info:SetFont("ixSmallFont")
		info:SetText(L("helpFlags"))
		info:SetContentAlignment(5)
		info:SetTextColor(color_white)
		info:SetExpensiveShadow(1, color_black)
		info:Dock(TOP)
		info:DockMargin(0, 0, 0, 8)
		info:SizeToContents()
		info:SetTall(info:GetTall() + 16)

		info.Paint = function(_, width, height)
			surface.SetDrawColor(ColorAlpha(derma.GetColor("Info", info), 160))
			surface.DrawRect(0, 0, width, height)
		end

		-- flags
		for k, v in SortedPairs(ix.flag.list) do
			local background = ColorAlpha(
				LocalPlayer():GetCharacter():HasFlags(k) and derma.GetColor("Success", info) or derma.GetColor("Error", info), 88
			)

			local panel = container:Add("Panel")
			panel:Dock(TOP)
			panel:DockMargin(0, 0, 0, 8)
			panel:DockPadding(4, 4, 4, 4)
			panel.Paint = function(_, width, height)
				derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, background)
			end

			local flag = panel:Add("DLabel")
			flag:SetFont("ixMonoMediumFont")
			flag:SetText(string.format("[%s]", k))
			flag:Dock(LEFT)
			flag:SetTextColor(color_white)
			flag:SetExpensiveShadow(1, color_black)
			flag:SetTextInset(4, 0)
			flag:SizeToContents()
			flag:SetTall(flag:GetTall() + 8)

			local description = panel:Add("DLabel")
			description:SetFont("ixMediumLightFont")
			description:SetText(v.description)
			description:Dock(FILL)
			description:SetTextColor(color_white)
			description:SetExpensiveShadow(1, color_black)
			description:SetTextInset(8, 0)
			description:SizeToContents()
			description:SetTall(description:GetTall() + 8)

			panel:SizeToChildren(false, true)
		end
	end

	tabs["plugins"] = function(container)
		for _, v in SortedPairsByMemberValue(ix.plugin.list, "name") do
			-- name
			local title = container:Add("DLabel")
			title:SetFont("ixMediumLightFont")
			title:SetText(v.name or "Unknown")
			title:Dock(TOP)
			title:SetTextColor(ix.config.Get("color"))
			title:SetExpensiveShadow(1, color_black)
			title:SizeToContents()

			-- author
			local author = container:Add("DLabel")
			author:SetFont("ixSmallFont")
			author:SetText(string.format("%s: %s", L("author"), v.author))
			author:Dock(TOP)
			author:SetTextColor(color_white)
			author:SetExpensiveShadow(1, color_black)
			author:SetWrap(true)
			author:SetAutoStretchVertical(true)
			author:SizeToContents()

			-- description
			local descriptionText = v.description

			if (descriptionText != "") then
				local description = container:Add("DLabel")
				description:SetFont("ixSmallFont")
				description:SetText(descriptionText)
				description:Dock(TOP)
				description:SetTextColor(color_white)
				description:SetExpensiveShadow(1, color_black)
				description:SetWrap(true)
				description:SetAutoStretchVertical(true)
				description:SizeToContents()
				description:DockMargin(0, 0, 0, 8)
			else
				author:DockMargin(0, 0, 0, 8)
			end
		end
	end

	tabs["Лор"] = function(container)
		for k, v in SortedPairs(textLore) do
			local category = container:Add("DLabel")
			category:SetFont("qTitleFont")
			category:SetText(v.title)
			category:Dock(TOP)
			category:SetTextColor(ix.config.Get("color"))
			category:SetExpensiveShadow(1, color_black)
			category:SetContentAlignment(5)
			category:SetAutoStretchVertical(true)
			category:SizeToContents()
			category:DockMargin(0, 0, 0, 8)

			local onetext = container:Add("DLabel")
			onetext:SetFont("qMediumLightFont")
			onetext:SetText(v.onetext)
			onetext:Dock(TOP)
			onetext:SetWrap(true)
			onetext:SetTextColor(color_white)
			onetext:SetAutoStretchVertical(true)
			onetext:SizeToContents()
			onetext:DockMargin(5, 0, 0, 8)

			if v.twotext then
				local twotext = container:Add("DLabel")
				twotext:SetFont("qMediumLightFont")
				twotext:SetText(v.twotext)
				twotext:Dock(TOP)
				twotext:SetWrap(true)
				twotext:SetTextColor(color_white)
				twotext:SetAutoStretchVertical(true)
				twotext:SizeToContents()
				twotext:DockMargin(5, 0, 0, 8)
			end

			if v.threetext then
				local threetext = container:Add("DLabel")
				threetext:SetFont("qMediumLightFont")
				threetext:SetText(v.threetext)
				threetext:Dock(TOP)
				threetext:SetWrap(true)
				threetext:SetTextColor(color_white)
				threetext:SetAutoStretchVertical(true)
				threetext:SizeToContents()
				threetext:DockMargin(5, 0, 0, 8)
			end

			if v.fourtext then
				local fourtext = container:Add("DLabel")
				fourtext:SetFont("qMediumLightFont")
				fourtext:SetText(v.fourtext)
				fourtext:Dock(TOP)
				fourtext:SetWrap(true)
				fourtext:SetTextColor(color_white)
				fourtext:SetAutoStretchVertical(true)
				fourtext:SizeToContents()
				fourtext:DockMargin(5, 0, 0, 8)
			end

			if v.fivetext then
				local fivetext = container:Add("DLabel")
				fivetext:SetFont("qMediumLightFont")
				fivetext:SetText(v.fivetext)
				fivetext:Dock(TOP)
				fivetext:SetWrap(true)
				fivetext:SetTextColor(color_white)
				fivetext:SetAutoStretchVertical(true)
				fivetext:SizeToContents()
				fivetext:DockMargin(5, 0, 0, 8)
			end
		end
	end
	tabs["Законы"] = function(container)
		for k, v in SortedPairs(textRule) do
			local category = container:Add("DLabel")
			category:SetFont("qTitleFont")
			category:SetText(v.title)
			category:Dock(TOP)
			category:SetTextColor(ix.config.Get("color"))
			category:SetExpensiveShadow(1, color_black)
			category:SetContentAlignment(5)
			category:SetAutoStretchVertical(true)
			category:SizeToContents()
			category:DockMargin(0, 0, 0, 8)

			local onetext = container:Add("DLabel")
			onetext:SetFont("qMediumLightFont")
			onetext:SetText(v.onetext)
			onetext:Dock(TOP)
			onetext:SetWrap(true)
			onetext:SetContentAlignment(5)
			onetext:SetTextColor(color_white)
			onetext:SetAutoStretchVertical(true)
			onetext:SizeToContents()
			onetext:DockMargin(5, 0, 0, 8)

			if v.twotext then
				local twotext = container:Add("DLabel")
				twotext:SetFont("qMediumLightFont")
				twotext:SetText(v.twotext)
				twotext:Dock(TOP)
				twotext:SetWrap(true)
				twotext:SetTextColor(color_white)
				twotext:SetAutoStretchVertical(true)
				twotext:SizeToContents()
				twotext:DockMargin(5, 0, 0, 8)
			end

			if v.threetext then
				local threetext = container:Add("DLabel")
				threetext:SetFont("qMediumLightFont")
				threetext:SetText(v.threetext)
				threetext:Dock(TOP)
				threetext:SetWrap(true)
				threetext:SetTextColor(color_white)
				threetext:SetAutoStretchVertical(true)
				threetext:SizeToContents()
				threetext:DockMargin(5, 0, 0, 8)
			end

			if v.fourtext then
				local fourtext = container:Add("DLabel")
				fourtext:SetFont("qMediumLightFont")
				fourtext:SetText(v.fourtext)
				fourtext:Dock(TOP)
				fourtext:SetWrap(true)
				fourtext:SetTextColor(color_white)
				fourtext:SetAutoStretchVertical(true)
				fourtext:SizeToContents()
				fourtext:DockMargin(5, 0, 0, 8)
			end

			if v.fivetext then
				local fivetext = container:Add("DLabel")
				fivetext:SetFont("qMediumLightFont")
				fivetext:SetText(v.fivetext)
				fivetext:Dock(TOP)
				fivetext:SetWrap(true)
				fivetext:SetTextColor(color_white)
				fivetext:SetAutoStretchVertical(true)
				fivetext:SizeToContents()
				fivetext:DockMargin(5, 0, 0, 8)
			end
		end
	end
end)
