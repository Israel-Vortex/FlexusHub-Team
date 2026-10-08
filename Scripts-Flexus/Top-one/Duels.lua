
local WindUI
do
    local urls = {
        "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua",
        "https://cdn.jsdelivr.net/gh/Footagesus/WindUI@main/dist/main.lua",
        "https://raw.githubusercontent.com/Synergy-Team-Official/Scripts/refs/heads/main/Uis/WindUI-Shiny.lua",
        "https://raw.githubusercontent.com/Israel-Vortex/FlexusHub-Team/refs/heads/main/FlexusHub/Flexus-Lib/Flexus-Team/WindUi-FlexusHub.lua",
    }
    for _, url in ipairs(urls) do
        local ok, res = pcall(function()
            return loadstring(game:HttpGet(url))()
        end)
        if ok and res then
            WindUI = res
            break
        else
            warn("[FlexusHub][Duels] WindUI fail:", tostring(res))
        end
    end
end
if not WindUI then
    error("[FlexusHub][Duels] No se pudo cargar WindUI")
end

local UserInputService = game:GetService("UserInputService")
local isPC = (function()
    local uis = UserInputService
    -- Movil si hay touch y no teclado fisico
    if uis.TouchEnabled and not uis.KeyboardEnabled then
        return false
    end
    local ok, platform = pcall(function()
        return uis:GetPlatform()
    end)
    if ok and (platform == Enum.Platform.Android or platform == Enum.Platform.IOS) then
        return false
    end
    -- PC solo si hay teclado o mouse y no es solo touch
    if uis.KeyboardEnabled or uis.MouseEnabled then
        if uis.TouchEnabled and not uis.KeyboardEnabled then
            return false
        end
        return true
    end
    return false
end)()

local SUPPORTED_LANGUAGES = { en = true, fr = true, ru = true, vi = true }

local translations = {
    en = {
        ["tab.information"] = "Information", ["section.information"] = "About", ["info.project"] = "FlexusHub [Duels]",
        ["info.project_desc"] = "Multi-executor script for Duels (Murderers vs Sheriffs).\nCombat, ESP, farm, visuals and more.\nCompatible with PC and mobile (Delta, Hydrogen, CodeX, etc.).\n\nDeveloper: FlexusHub\nUI: WindUI\nVersion: 1.0",
        ["section.community"] = "Community",
        ["discord.banner_title"] = "FlexusHub Discord",
        ["discord.banner_desc"] = "Join the official server for support, updates and community.",
        ["button.discord"] = "Copy Discord Invite", ["button.website"] = "Copy Website Link", ["section.appearance"] = "Appearance",
        ["control.language"] = "Interface Language", ["control.theme"] = "Interface Theme", ["section.report"] = "Report Bug / Suggestion",
        ["option.language.en"] = "English", ["option.language.fr"] = "French", ["option.language.ru"] = "Russian", ["option.language.vi"] = "Vietnamese", ["control.message"] = "Message",
        ["placeholder.report"] = "Describe the bug or suggestion...", ["button.send_report"] = "Send Report",
        ["tab.keybinds"] = "Keybinds", ["section.interface"] = "Interface", ["control.toggle_ui"] = "Toggle UI", ["section.feature_keybinds"] = "Feature Keybinds",
        ["control.esp"] = "ESP", ["control.triggerbot"] = "Triggerbot", ["control.silent_aim"] = "Silent Aim", ["control.aimbot_camlock"] = "Aimbot (Camlock)",
        ["tab.aimbot"] = "Aimbot", ["section.aimbot"] = "Aimbot", ["toggle.enable_aimbot"] = "Enable Aimbot", ["toggle.show_fov"] = "Show FOV Circle", ["toggle.wall_check"] = "Wall Check",
        ["dropdown.target_part"] = "Target Part", ["dropdown.aim_mode"] = "Aim Mode", ["slider.smoothness"] = "Smoothness", ["slider.fov_radius"] = "FOV Radius", ["color.fov"] = "FOV Color",
        ["toggle.only_gun"] = "Only Gun",
        ["tab.triggerbot"] = "Trigger Bot", ["section.triggerbot"] = "Trigger Bot", ["toggle.enable_triggerbot"] = "Enable Trigger Bot", ["toggle.hold_click"] = "Hold Click / Continuous",
        ["section.targeting"] = "Targeting Configuration", ["slider.hit_chance"] = "Hit Chance", ["slider.reaction_delay"] = "Reaction Delay", ["slider.target_radius"] = "Target Radius",
        ["toggle.line_of_sight"] = "Require Line of Sight", ["toggle.team_check"] = "Team Check", ["tab.auto_shoot"] = "Auto Shoot", ["section.auto_shoot"] = "Auto Shoot",
        ["toggle.auto_shoot"] = "Auto Shoot", ["dropdown.target_body_part"] = "Target: Body Part",
        ["tab.silent_aim"] = "Silent Aim", ["section.silent_aim"] = "Silent Aim", ["toggle.silent_aim"] = "Silent Aim", ["slider.prediction_hit_chance"] = "Prediction / Hit Chance",
        ["tab.esp"] = "ESP", ["section.player_visuals"] = "Player Visuals", ["toggle.enable_esp"] = "Enable ESP", ["toggle.show_names"] = "Show Names",
        ["slider.box_transparency"] = "Box Transparency", ["color.box"] = "Box Color", ["color.outline"] = "Outline Color", ["color.text"] = "Text Color", ["slider.outline_thickness"] = "Outline Thickness",
        ["tab.visual"] = "Visual", ["section.change_names"] = "Change Names", ["toggle.change_my_username"] = "Change My Username", ["toggle.change_other_names"] = "Change Other Player Names",
        ["section.skybox"] = "Skybox", ["dropdown.choose_skybox"] = "Choose Skybox", ["button.restore_sky"] = "Restore Original Sky", ["section.rtx"] = "RTX",
        ["dropdown.lighting_preset"] = "Lighting Preset", ["button.restore_visuals"] = "Restore Original Visuals", ["section.environment"] = "Environment", ["slider.time_of_day"] = "Time of Day",
        ["slider.brightness"] = "Brightness", ["slider.exposure"] = "Exposure", ["slider.fog_distance"] = "Fog Distance", ["color.ambient"] = "Ambient Color",
        ["tab.extra"] = "Extra", ["section.macro_gun"] = "Macro (Gun)", ["toggle.enable_macro"] = "Enable Macro", ["slider.equip_delay"] = "Equip Delay", ["slider.shoot_delay"] = "Shoot Delay",
        ["section.kill_sound"] = "Kill Sound", ["toggle.kill_sound"] = "Kill Sound", ["dropdown.kill_sound"] = "Kill Sound ID", ["section.loop_tp"] = "LoopTP", ["toggle.loop_tp"] = "LoopTP", ["dropdown.loop_tp_player"] = "Player", ["button.refresh_players"] = "Refresh Players",
        ["section.auto_macro_360"] = "Auto Macro 360", ["toggle.auto_macro_360"] = "Auto Macro 360", ["slider.auto_macro_range"] = "360 Range", ["toggle.auto_macro_team_check"] = "Team Check", ["toggle.auto_macro_wall_check"] = "Wall Check", ["dropdown.auto_macro_part"] = "Target Part", ["slider.auto_macro_scan_delay"] = "Scan Delay",
        ["section.dead_zone"] = "Dead Zone", ["toggle.show_adjust_dead_zone"] = "Show/Adjust Dead Zone", ["slider.dead_zone_size"] = "Dead Zone Size", ["overlay.dead_zone"] = "DEAD ZONE\n(Drag)",
        ["tab.animations"] = "Animations", ["section.full_animation_packs"] = "Full Animation Packs", ["dropdown.choose_pack"] = "Choose Pack", ["button.apply_full_pack"] = "Apply Full Pack",
        ["button.restore_default"] = "Restore Default", ["section.animation_mixer"] = "Animation Mixer", ["dropdown.idle"] = "Idle", ["dropdown.walk"] = "Walk", ["dropdown.run"] = "Run",
        ["dropdown.jump"] = "Jump", ["dropdown.fall"] = "Fall", ["dropdown.climb"] = "Climb", ["button.mix_apply"] = "Mix and Apply", ["toggle.auto_mix_apply"] = "Auto Mix Apply",
        ["option.graphite"] = "Graphite", ["option.neon_blue"] = "Neon Blue", ["option.golden"] = "Golden", ["option.head"] = "Head", ["option.torso"] = "Torso", ["option.full_body"] = "Full Body", ["option.mode_360"] = "360", ["option.screen"] = "Screen", ["option.fov"] = "FOV", ["option.original"] = "Original", ["option.cinematic"] = "Cinematic", ["option.performance"] = "Performance",
        ["state.on"] = "Enabled", ["state.off"] = "Disabled", ["notification.state"] = "%s: %s",
        ["notification.discord_copied"] = "Discord link copied", ["notification.website_copied"] = "Website link copied", ["notification.wait"] = "Wait %d seconds.",
        ["notification.enter_message"] = "Please enter a message.", ["notification.report_sent"] = "Report sent. Thank you.", ["notification.report_failed"] = "Unable to send report.",
        ["notification.skybox_file"] = "This skybox requires executor file support.", ["notification.skybox_download"] = "Could not download %s.",
        ["notification.skybox_register"] = "Could not register %s for %s.", ["notification.skybox_preload"] = "Could not preload all faces for %s.",
        ["notification.skybox_changed"] = "Skybox: %s", ["notification.sky_restored"] = "Original sky restored.", ["notification.rtx_changed"] = "RTX: %s", ["notification.visuals_restored"] = "Original visuals restored.",
        ["popup.executor_warning.title"] = "Notice", ["popup.executor_warning.content"] = "Executors such as Xeno and Solara have very low UNC. What does this mean? You cannot use Silent Aim or Auto Shoot. We recommend switching to an executor such as \"Real\" or \"Madium\", or to \"Velocity\".", ["button.ok"] = "OK",
    },
    fr = {
        ["tab.information"] = "Informations", ["section.information"] = "À propos", ["info.project"] = "FlexusHub [Duels]",
        ["info.project_desc"] = "Script multi-exécuteur pour Duels.\nCombat, ESP, farm, visuels et plus.\nCompatible PC et mobile.\n\nDéveloppeur: FlexusHub\nUI: WindUI\nVersion: 1.0",
        ["section.community"] = "Communauté",
        ["discord.banner_title"] = "Discord FlexusHub",
        ["discord.banner_desc"] = "Rejoignez le serveur officiel pour le support et les mises à jour.",
        ["button.discord"] = "Copier l'invitation Discord", ["button.website"] = "Copier le lien du site", ["section.appearance"] = "Apparence", ["control.language"] = "Langue de l'interface", ["control.theme"] = "Thème de l'interface",
        ["option.language.en"] = "Anglais", ["option.language.fr"] = "Français", ["option.language.ru"] = "Russe", ["option.language.vi"] = "Vietnamien",
        ["section.report"] = "Signaler un bug / proposer une idée", ["control.message"] = "Message", ["placeholder.report"] = "Décrivez le bug ou la suggestion...", ["button.send_report"] = "Envoyer le rapport",
        ["tab.keybinds"] = "Raccourcis clavier", ["section.interface"] = "Interface", ["control.toggle_ui"] = "Afficher/masquer l'interface", ["section.feature_keybinds"] = "Raccourcis des fonctionnalités",
        ["control.esp"] = "ESP", ["control.triggerbot"] = "Triggerbot", ["control.silent_aim"] = "Visée silencieuse", ["control.aimbot_camlock"] = "Aimbot (Camlock)",
        ["tab.aimbot"] = "Aimbot", ["section.aimbot"] = "Aimbot", ["toggle.enable_aimbot"] = "Activer l'aimbot", ["toggle.show_fov"] = "Afficher le cercle FOV", ["toggle.wall_check"] = "Vérification des murs",
        ["dropdown.target_part"] = "Partie ciblée", ["dropdown.aim_mode"] = "Mode de visée", ["slider.smoothness"] = "Fluidité", ["slider.fov_radius"] = "Rayon du FOV", ["color.fov"] = "Couleur du FOV",
        ["toggle.only_gun"] = "Seulement arme à feu",
        ["tab.triggerbot"] = "Trigger Bot", ["section.triggerbot"] = "Trigger Bot", ["toggle.enable_triggerbot"] = "Activer le Trigger Bot", ["toggle.hold_click"] = "Maintenir le clic / continu",
        ["section.targeting"] = "Configuration du ciblage", ["slider.hit_chance"] = "Chance de toucher", ["slider.reaction_delay"] = "Délai de réaction", ["slider.target_radius"] = "Rayon de ciblage",
        ["toggle.line_of_sight"] = "Exiger une ligne de vue", ["toggle.team_check"] = "Vérification d'équipe", ["tab.auto_shoot"] = "Tir automatique", ["section.auto_shoot"] = "Tir automatique",
        ["toggle.auto_shoot"] = "Tir automatique", ["dropdown.target_body_part"] = "Cible : partie du corps",
        ["tab.silent_aim"] = "Visée silencieuse", ["section.silent_aim"] = "Visée silencieuse", ["toggle.silent_aim"] = "Visée silencieuse", ["slider.prediction_hit_chance"] = "Prédiction / chance de toucher",
        ["tab.esp"] = "ESP", ["section.player_visuals"] = "Visuels des joueurs", ["toggle.enable_esp"] = "Activer l'ESP", ["toggle.show_names"] = "Afficher les noms",
        ["slider.box_transparency"] = "Transparence de la boîte", ["color.box"] = "Couleur de la boîte", ["color.outline"] = "Couleur du contour", ["color.text"] = "Couleur du texte", ["slider.outline_thickness"] = "Épaisseur du contour",
        ["tab.visual"] = "Visuel", ["section.change_names"] = "Modifier les noms", ["toggle.change_my_username"] = "Modifier mon nom d'utilisateur", ["toggle.change_other_names"] = "Modifier les noms des autres joueurs",
        ["section.skybox"] = "Ciel", ["dropdown.choose_skybox"] = "Choisir le ciel", ["button.restore_sky"] = "Restaurer le ciel d'origine", ["section.rtx"] = "RTX",
        ["dropdown.lighting_preset"] = "Préréglage d'éclairage", ["button.restore_visuals"] = "Restaurer les visuels d'origine", ["section.environment"] = "Environnement", ["slider.time_of_day"] = "Heure de la journée",
        ["slider.brightness"] = "Luminosité", ["slider.exposure"] = "Exposition", ["slider.fog_distance"] = "Distance du brouillard", ["color.ambient"] = "Couleur ambiante",
        ["tab.extra"] = "Extra", ["section.macro_gun"] = "Macro (arme)", ["toggle.enable_macro"] = "Activer la macro", ["slider.equip_delay"] = "Délai d'équipement", ["slider.shoot_delay"] = "Délai de tir",
        ["section.kill_sound"] = "Sonido de kill", ["toggle.kill_sound"] = "Sonido de kill", ["dropdown.kill_sound"] = "Elegir sonido",
        ["section.auto_macro_360"] = "Auto Macro 360", ["toggle.auto_macro_360"] = "Auto Macro 360", ["slider.auto_macro_range"] = "Portée 360", ["toggle.auto_macro_team_check"] = "Vérification d'équipe", ["toggle.auto_macro_wall_check"] = "Vérification des murs", ["dropdown.auto_macro_part"] = "Partie ciblée", ["slider.auto_macro_scan_delay"] = "Délai de détection",
        ["section.dead_zone"] = "Zone morte", ["toggle.show_adjust_dead_zone"] = "Afficher/ajuster la zone morte", ["slider.dead_zone_size"] = "Taille de la zone morte", ["overlay.dead_zone"] = "ZONE MORTE\n(Faire glisser)",
        ["tab.animations"] = "Animations", ["section.full_animation_packs"] = "Packs d'animations complets", ["dropdown.choose_pack"] = "Choisir un pack", ["button.apply_full_pack"] = "Appliquer le pack complet",
        ["button.restore_default"] = "Restaurer par défaut", ["section.animation_mixer"] = "Mélangeur d'animations", ["dropdown.idle"] = "Inactif", ["dropdown.walk"] = "Marche", ["dropdown.run"] = "Course",
        ["dropdown.jump"] = "Saut", ["dropdown.fall"] = "Chute", ["dropdown.climb"] = "Escalade", ["button.mix_apply"] = "Mélanger et appliquer", ["toggle.auto_mix_apply"] = "Application automatique du mix",
        ["option.graphite"] = "Graphite", ["option.neon_blue"] = "Bleu néon", ["option.golden"] = "Doré", ["option.head"] = "Tête", ["option.torso"] = "Torse", ["option.full_body"] = "Corps entier", ["option.mode_360"] = "360", ["option.screen"] = "Écran", ["option.fov"] = "FOV", ["option.original"] = "Original", ["option.cinematic"] = "Cinématique", ["option.performance"] = "Performance",
        ["state.on"] = "Activé", ["state.off"] = "Désactivé", ["notification.state"] = "%s : %s",
        ["notification.discord_copied"] = "Lien Discord copié", ["notification.website_copied"] = "Lien du site copié", ["notification.wait"] = "Attendez %d secondes.",
        ["notification.enter_message"] = "Veuillez saisir un message.", ["notification.report_sent"] = "Rapport envoyé. Merci.", ["notification.report_failed"] = "Impossible d'envoyer le rapport.",
        ["notification.skybox_file"] = "Ce ciel nécessite l'accès aux fichiers de l'exécuteur.", ["notification.skybox_download"] = "Impossible de télécharger %s.",
        ["notification.skybox_register"] = "Impossible d'enregistrer %s pour %s.", ["notification.skybox_preload"] = "Impossible de précharger toutes les faces de %s.",
        ["notification.skybox_changed"] = "Ciel : %s", ["notification.sky_restored"] = "Ciel d'origine restauré.", ["notification.rtx_changed"] = "RTX : %s", ["notification.visuals_restored"] = "Visuels d'origine restaurés.",
        ["popup.executor_warning.title"] = "Avertissement", ["popup.executor_warning.content"] = "Les exécuteurs comme Xeno et Solara ont un UNC très faible. Qu'est-ce que cela signifie ? Vous ne pouvez pas utiliser Silent Aim ni Auto Shoot. Nous vous recommandons de passer à un exécuteur comme \"Real\" ou \"Madium\", ou comme \"Velocity\".", ["button.ok"] = "OK",
    },
    ru = {
        ["tab.information"] = "Информация", ["section.information"] = "О скрипте", ["info.project"] = "FlexusHub [Duels]",
        ["info.project_desc"] = "Мульти-экзекьютор скрипт для Duels.\nБой, ESP, фарм, визуалы и другое.\nPC и мобильные.\n\nРазработчик: FlexusHub\nUI: WindUI\nVersion: 1.0",
        ["section.community"] = "Сообщество",
        ["discord.banner_title"] = "Discord FlexusHub",
        ["discord.banner_desc"] = "Присоединяйтесь к официальному серверу.",
        ["button.discord"] = "Скопировать Discord", ["button.website"] = "Скопировать сайт", ["section.appearance"] = "Внешний вид", ["control.language"] = "Язык интерфейса", ["control.theme"] = "Тема интерфейса",
        ["option.language.en"] = "Английский", ["option.language.fr"] = "Французский", ["option.language.ru"] = "Русский", ["option.language.vi"] = "Вьетнамский",
        ["section.report"] = "Сообщить об ошибке / предложении", ["control.message"] = "Сообщение", ["placeholder.report"] = "Опишите ошибку или предложение...", ["button.send_report"] = "Отправить отчёт",
        ["tab.keybinds"] = "Клавиши", ["section.interface"] = "Интерфейс", ["control.toggle_ui"] = "Переключение интерфейса", ["section.feature_keybinds"] = "Клавиши функций",
        ["control.esp"] = "ESP", ["control.triggerbot"] = "Триггербот", ["control.silent_aim"] = "Тихое прицеливание", ["control.aimbot_camlock"] = "Аимбот (Camlock)",
        ["tab.aimbot"] = "Аимбот", ["section.aimbot"] = "Аимбот", ["toggle.enable_aimbot"] = "Включить аимбот", ["toggle.show_fov"] = "Показывать круг FOV", ["toggle.wall_check"] = "Проверка стен",
        ["dropdown.target_part"] = "Целевая часть", ["dropdown.aim_mode"] = "Режим прицеливания", ["slider.smoothness"] = "Плавность", ["slider.fov_radius"] = "Радиус FOV", ["color.fov"] = "Цвет FOV",
        ["toggle.only_gun"] = "Только оружие",
        ["tab.triggerbot"] = "Триггербот", ["section.triggerbot"] = "Триггербот", ["toggle.enable_triggerbot"] = "Включить триггербот", ["toggle.hold_click"] = "Удерживать клик / непрерывно",
        ["section.targeting"] = "Настройка прицеливания", ["slider.hit_chance"] = "Шанс попадания", ["slider.reaction_delay"] = "Задержка реакции", ["slider.target_radius"] = "Радиус цели",
        ["toggle.line_of_sight"] = "Требовать прямую видимость", ["toggle.team_check"] = "Проверка команды", ["tab.auto_shoot"] = "Автоматическая стрельба", ["section.auto_shoot"] = "Автоматическая стрельба",
        ["toggle.auto_shoot"] = "Автоматическая стрельба", ["dropdown.target_body_part"] = "Цель: часть тела",
        ["tab.silent_aim"] = "Тихое прицеливание", ["section.silent_aim"] = "Тихое прицеливание", ["toggle.silent_aim"] = "Тихое прицеливание", ["slider.prediction_hit_chance"] = "Прогноз / шанс попадания",
        ["tab.esp"] = "ESP", ["section.player_visuals"] = "Визуализация игроков", ["toggle.enable_esp"] = "Включить ESP", ["toggle.show_names"] = "Показывать имена",
        ["slider.box_transparency"] = "Прозрачность рамки", ["color.box"] = "Цвет рамки", ["color.outline"] = "Цвет контура", ["color.text"] = "Цвет текста", ["slider.outline_thickness"] = "Толщина контура",
        ["tab.visual"] = "Визуализация", ["section.change_names"] = "Изменение имён", ["toggle.change_my_username"] = "Изменить моё имя пользователя", ["toggle.change_other_names"] = "Изменить имена других игроков",
        ["section.skybox"] = "Небо", ["dropdown.choose_skybox"] = "Выбрать небо", ["button.restore_sky"] = "Восстановить исходное небо", ["section.rtx"] = "RTX",
        ["dropdown.lighting_preset"] = "Пресет освещения", ["button.restore_visuals"] = "Восстановить исходную визуализацию", ["section.environment"] = "Окружение", ["slider.time_of_day"] = "Время суток",
        ["slider.brightness"] = "Яркость", ["slider.exposure"] = "Экспозиция", ["slider.fog_distance"] = "Дальность тумана", ["color.ambient"] = "Цвет окружения",
        ["tab.extra"] = "Дополнительно", ["section.macro_gun"] = "Макрос (оружие)", ["toggle.enable_macro"] = "Включить макрос", ["slider.equip_delay"] = "Задержка экипировки", ["slider.shoot_delay"] = "Задержка выстрела",
        ["section.kill_sound"] = "Звук убийства", ["toggle.kill_sound"] = "Звук убийства", ["dropdown.kill_sound"] = "Звук",
        ["section.auto_macro_360"] = "Auto Macro 360", ["toggle.auto_macro_360"] = "Auto Macro 360", ["slider.auto_macro_range"] = "Радиус 360", ["toggle.auto_macro_team_check"] = "Проверка команды", ["toggle.auto_macro_wall_check"] = "Проверка стен", ["dropdown.auto_macro_part"] = "Целевая часть", ["slider.auto_macro_scan_delay"] = "Задержка сканирования",
        ["section.dead_zone"] = "Мёртвая зона", ["toggle.show_adjust_dead_zone"] = "Показывать/настроить мёртвую зону", ["slider.dead_zone_size"] = "Размер мёртвой зоны", ["overlay.dead_zone"] = "МЁРТВАЯ ЗОНА\n(Перетащите)",
        ["tab.animations"] = "Анимации", ["section.full_animation_packs"] = "Полные наборы анимаций", ["dropdown.choose_pack"] = "Выбрать набор", ["button.apply_full_pack"] = "Применить полный набор",
        ["button.restore_default"] = "Восстановить стандартные", ["section.animation_mixer"] = "Микшер анимаций", ["dropdown.idle"] = "Покой", ["dropdown.walk"] = "Ходьба", ["dropdown.run"] = "Бег",
        ["dropdown.jump"] = "Прыжок", ["dropdown.fall"] = "Падение", ["dropdown.climb"] = "Лазание", ["button.mix_apply"] = "Смешать и применить", ["toggle.auto_mix_apply"] = "Автоматическое применение микса",
        ["option.graphite"] = "Графит", ["option.neon_blue"] = "Неон. синий", ["option.golden"] = "Золотой", ["option.head"] = "Голова", ["option.torso"] = "Торс", ["option.full_body"] = "Всё тело", ["option.mode_360"] = "360", ["option.screen"] = "Экран", ["option.fov"] = "FOV", ["option.original"] = "Исходный", ["option.cinematic"] = "Кинематографичный", ["option.performance"] = "Производительность",
        ["state.on"] = "Включено", ["state.off"] = "Выключено", ["notification.state"] = "%s: %s",
        ["notification.discord_copied"] = "Ссылка Discord скопирована", ["notification.website_copied"] = "Ссылка на сайт скопирована", ["notification.wait"] = "Подождите %d секунд.",
        ["notification.enter_message"] = "Введите сообщение.", ["notification.report_sent"] = "Отчёт отправлен. Спасибо.", ["notification.report_failed"] = "Не удалось отправить отчёт.",
        ["notification.skybox_file"] = "Для этого неба нужна поддержка файлового доступа исполнителя.", ["notification.skybox_download"] = "Не удалось скачать %s.",
        ["notification.skybox_register"] = "Не удалось зарегистрировать %s для %s.", ["notification.skybox_preload"] = "Не удалось предварительно загрузить все грани %s.",
        ["notification.skybox_changed"] = "Небо: %s", ["notification.sky_restored"] = "Исходное небо восстановлено.", ["notification.rtx_changed"] = "RTX: %s", ["notification.visuals_restored"] = "Исходная визуализация восстановлена.",
        ["popup.executor_warning.title"] = "Предупреждение", ["popup.executor_warning.content"] = "У исполнителей, таких как Xeno и Solara, очень низкий UNC. Что это значит? Вы не можете использовать Silent Aim или Auto Shoot. Рекомендуем сменить исполнителя на \"Real\", \"Madium\" или \"Velocity\".", ["button.ok"] = "ОК",
    },
    vi = {
        ["tab.information"] = "Thông tin", ["section.information"] = "Giới thiệu", ["info.project"] = "FlexusHub [Duels]",
        ["info.project_desc"] = "Script multi-executor cho Duels.\nCombat, ESP, farm, visuals.\nPC và mobile.\n\nDeveloper: FlexusHub\nUI: WindUI\nVersion: 1.0",
        ["section.community"] = "Cộng đồng",
        ["discord.banner_title"] = "Discord FlexusHub",
        ["discord.banner_desc"] = "Tham gia server chính thức để hỗ trợ và cập nhật.",
        ["button.discord"] = "Sao chép Discord", ["button.website"] = "Sao chép Website", ["section.appearance"] = "Giao diện", ["control.language"] = "Ngôn ngữ giao diện", ["control.theme"] = "Chủ đề giao diện",
        ["option.language.en"] = "Tiếng Anh", ["option.language.fr"] = "Tiếng Pháp", ["option.language.ru"] = "Tiếng Nga", ["option.language.vi"] = "Tiếng Việt",
        ["section.report"] = "Báo lỗi / Đề xuất", ["control.message"] = "Tin nhắn", ["placeholder.report"] = "Mô tả lỗi hoặc đề xuất...", ["button.send_report"] = "Gửi báo cáo",
        ["tab.keybinds"] = "Phím tắt", ["section.interface"] = "Giao diện", ["control.toggle_ui"] = "Bật/tắt giao diện", ["section.feature_keybinds"] = "Phím tắt tính năng",
        ["control.esp"] = "ESP", ["control.triggerbot"] = "Triggerbot", ["control.silent_aim"] = "Ngắm im lặng", ["control.aimbot_camlock"] = "Aimbot (Camlock)",
        ["tab.aimbot"] = "Aimbot", ["section.aimbot"] = "Aimbot", ["toggle.enable_aimbot"] = "Bật Aimbot", ["toggle.show_fov"] = "Hiện vòng tròn FOV", ["toggle.wall_check"] = "Kiểm tra tường",
        ["dropdown.target_part"] = "Bộ phận mục tiêu", ["dropdown.aim_mode"] = "Chế độ ngắm", ["slider.smoothness"] = "Độ mượt", ["slider.fov_radius"] = "Bán kính FOV", ["color.fov"] = "Màu FOV",
        ["toggle.only_gun"] = "Chỉ súng",
        ["tab.triggerbot"] = "Trigger Bot", ["section.triggerbot"] = "Trigger Bot", ["toggle.enable_triggerbot"] = "Bật Trigger Bot", ["toggle.hold_click"] = "Giữ chuột / liên tục",
        ["section.targeting"] = "Cấu hình nhắm mục tiêu", ["slider.hit_chance"] = "Tỷ lệ trúng", ["slider.reaction_delay"] = "Độ trễ phản ứng", ["slider.target_radius"] = "Bán kính mục tiêu",
        ["toggle.line_of_sight"] = "Yêu cầu tầm nhìn rõ", ["toggle.team_check"] = "Kiểm tra đội", ["tab.auto_shoot"] = "Tự động bắn", ["section.auto_shoot"] = "Tự động bắn",
        ["toggle.auto_shoot"] = "Tự động bắn", ["dropdown.target_body_part"] = "Mục tiêu: bộ phận cơ thể",
        ["tab.silent_aim"] = "Ngắm im lặng", ["section.silent_aim"] = "Ngắm im lặng", ["toggle.silent_aim"] = "Ngắm im lặng", ["slider.prediction_hit_chance"] = "Dự đoán / tỷ lệ trúng",
        ["tab.esp"] = "ESP", ["section.player_visuals"] = "Hiển thị người chơi", ["toggle.enable_esp"] = "Bật ESP", ["toggle.show_names"] = "Hiện tên",
        ["slider.box_transparency"] = "Độ trong suốt khung", ["color.box"] = "Màu khung", ["color.outline"] = "Màu viền", ["color.text"] = "Màu chữ", ["slider.outline_thickness"] = "Độ dày viền",
        ["tab.visual"] = "Hiển thị", ["section.change_names"] = "Đổi tên", ["toggle.change_my_username"] = "Đổi tên người dùng của tôi", ["toggle.change_other_names"] = "Đổi tên người chơi khác",
        ["section.skybox"] = "Bầu trời", ["dropdown.choose_skybox"] = "Chọn bầu trời", ["button.restore_sky"] = "Khôi phục bầu trời gốc", ["section.rtx"] = "RTX",
        ["dropdown.lighting_preset"] = "Thiết lập ánh sáng", ["button.restore_visuals"] = "Khôi phục hiển thị gốc", ["section.environment"] = "Môi trường", ["slider.time_of_day"] = "Thời gian trong ngày",
        ["slider.brightness"] = "Độ sáng", ["slider.exposure"] = "Độ phơi sáng", ["slider.fog_distance"] = "Khoảng cách sương mù", ["color.ambient"] = "Màu môi trường",
        ["tab.extra"] = "Khác", ["section.macro_gun"] = "Macro (súng)", ["toggle.enable_macro"] = "Bật Macro", ["slider.equip_delay"] = "Độ trễ trang bị", ["slider.shoot_delay"] = "Độ trễ bắn",
        ["section.kill_sound"] = "Âm thanh hạ gục", ["toggle.kill_sound"] = "Âm thanh hạ gục", ["dropdown.kill_sound"] = "Âm thanh",
        ["section.auto_macro_360"] = "Auto Macro 360", ["toggle.auto_macro_360"] = "Auto Macro 360", ["slider.auto_macro_range"] = "Phạm vi 360", ["toggle.auto_macro_team_check"] = "Kiểm tra đội", ["toggle.auto_macro_wall_check"] = "Kiểm tra tường", ["dropdown.auto_macro_part"] = "Bộ phận mục tiêu", ["slider.auto_macro_scan_delay"] = "Độ trễ quét",
        ["section.dead_zone"] = "Vùng chết", ["toggle.show_adjust_dead_zone"] = "Hiện/điều chỉnh vùng chết", ["slider.dead_zone_size"] = "Kích thước vùng chết", ["overlay.dead_zone"] = "VÙNG CHẾT\n(Kéo)",
        ["tab.animations"] = "Hoạt ảnh", ["section.full_animation_packs"] = "Gói hoạt ảnh đầy đủ", ["dropdown.choose_pack"] = "Chọn gói", ["button.apply_full_pack"] = "Áp dụng gói đầy đủ",
        ["button.restore_default"] = "Khôi phục mặc định", ["section.animation_mixer"] = "Bộ trộn hoạt ảnh", ["dropdown.idle"] = "Đứng yên", ["dropdown.walk"] = "Đi bộ", ["dropdown.run"] = "Chạy",
        ["dropdown.jump"] = "Nhảy", ["dropdown.fall"] = "Rơi", ["dropdown.climb"] = "Leo", ["button.mix_apply"] = "Trộn và áp dụng", ["toggle.auto_mix_apply"] = "Tự động áp dụng bản phối",
        ["option.graphite"] = "Than chì", ["option.neon_blue"] = "Xanh neon", ["option.golden"] = "Vàng gold", ["option.head"] = "Đầu", ["option.torso"] = "Thân", ["option.full_body"] = "Toàn thân", ["option.mode_360"] = "360", ["option.screen"] = "Màn hình", ["option.fov"] = "FOV", ["option.original"] = "Gốc", ["option.cinematic"] = "Điện ảnh", ["option.performance"] = "Hiệu năng",
        ["state.on"] = "Bật", ["state.off"] = "Tắt", ["notification.state"] = "%s: %s",
        ["notification.discord_copied"] = "Đã sao chép liên kết Discord", ["notification.website_copied"] = "Đã sao chép liên kết trang web", ["notification.wait"] = "Vui lòng đợi %d giây.",
        ["notification.enter_message"] = "Vui lòng nhập tin nhắn.", ["notification.report_sent"] = "Đã gửi báo cáo. Cảm ơn bạn.", ["notification.report_failed"] = "Không thể gửi báo cáo.",
        ["notification.skybox_file"] = "Bầu trời này yêu cầu trình thực thi hỗ trợ tệp.", ["notification.skybox_download"] = "Không thể tải %s.",
        ["notification.skybox_register"] = "Không thể đăng ký %s cho %s.", ["notification.skybox_preload"] = "Không thể tải trước toàn bộ mặt của %s.",
        ["notification.skybox_changed"] = "Bầu trời: %s", ["notification.sky_restored"] = "Đã khôi phục bầu trời gốc.", ["notification.rtx_changed"] = "RTX: %s", ["notification.visuals_restored"] = "Đã khôi phục hiển thị gốc.",
        ["popup.executor_warning.title"] = "Cảnh báo", ["popup.executor_warning.content"] = "Các executor như Xeno và Solara có UNC rất thấp. Điều này có nghĩa là gì? Bạn không thể sử dụng Silent Aim hoặc Auto Shoot. Chúng tôi khuyên bạn nên chuyển sang executor như \"Real\" hoặc \"Madium\", hoặc \"Velocity\".", ["button.ok"] = "OK",
    },
}

local function normalizeLanguage(language)
    local code = type(language) == "string" and language:lower():match("^[a-z]+") or nil
    return code and SUPPORTED_LANGUAGES[code] and code or "en"
end

local detectedLocale
pcall(function()
    detectedLocale = game:GetService("LocalizationService").SystemLocaleId
end)
local activeLanguage = normalizeLanguage(detectedLocale)

local function t(key, ...)
    local catalog = translations[activeLanguage] or translations.en
    local value = catalog[key] or translations.en[key] or key
    local args = {...}
    if #args > 0 then
        local ok, formatted = pcall(string.format, value, table.unpack(args))
        if ok then value = formatted end
    end
    return value
end

local function makeOptions(items)
    local options = {}
    for _, item in ipairs(items) do
        options[#options + 1] = {Title = t(item[1]), Value = item[2], I18nKey = item[1]}
    end
    return options
end

local function optionValue(selection, options)
    if type(selection) == "table" then
        return selection.Value or selection.Title
    end
    for _, option in ipairs(options or {}) do
        if selection == option.Value or selection == option.Title then
            return option.Value
        end
        if option.I18nKey then
            for language in pairs(translations) do
                if selection == translations[language][option.I18nKey] then
                    return option.Value
                end
            end
        end
    end
    return selection
end

local languageOptionDefinitions = {
    {"option.language.en", "en"},
    {"option.language.fr", "fr"},
    {"option.language.ru", "ru"},
    {"option.language.vi", "vi"},
}

local function optionByValue(options, value)
    for _, option in ipairs(options or {}) do
        if option.Value == value then
            return option
        end
    end
    return options and options[1] or nil
end

local languageOptions = makeOptions(languageOptionDefinitions)

local themeOptions = makeOptions({
    {"option.graphite", "Graphite"},
    {"option.neon_blue", "Neon Blue"},
    {"option.golden", "Golden"},
})
local targetPartOptions = makeOptions({
    {"option.head", "Head"},
    {"option.torso", "Torso"},
    {"option.full_body", "Full Body"},
})
local aimModeOptions = makeOptions({
    {"option.mode_360", "360"},
    {"option.screen", "Screen"},
    {"option.fov", "FOV"},
})
local lightingOptions = makeOptions({
    {"option.original", "Original"},
    {"option.cinematic", "Cinematic"},
    {"option.performance", "Performance"},
})

WindUI:Localization({
    Enabled = true,
    Prefix = "loc:",
    DefaultLanguage = "en",
    Translations = translations,
})
WindUI:SetLanguage(activeLanguage)

local function createTheme(name, colors)
    local theme = {}
    for key, value in pairs(WindUI:GetThemes().Dark) do
        theme[key] = value
    end
    theme.Name = name
    for key, value in pairs(colors) do
        theme[key] = value
    end
    WindUI:AddTheme(theme)
end

-- Graphite: blanco/gris neon (default, imagen monocroma)
createTheme("Graphite", {
    Accent = Color3.fromRGB(200, 200, 205),
    Dialog = Color3.fromRGB(12, 12, 14),
    Outline = Color3.fromRGB(180, 180, 185),
    Text = Color3.fromRGB(245, 245, 248),
    Placeholder = Color3.fromRGB(130, 130, 136),
    Background = Color3.fromRGB(8, 8, 10),
    Button = Color3.fromRGB(55, 55, 60),
    Icon = Color3.fromRGB(220, 220, 225),
    Toggle = Color3.fromRGB(210, 210, 215),
    Slider = Color3.fromRGB(190, 190, 195),
    Checkbox = Color3.fromRGB(210, 210, 215),
    PanelBackground = Color3.fromRGB(16, 16, 18),
    PanelBackgroundTransparency = 0.58,
    TabBackground = Color3.fromRGB(28, 28, 32),
    TabBackgroundHover = Color3.fromRGB(55, 55, 60),
    TabBackgroundHoverTransparency = 0.7,
    TabBackgroundActive = Color3.fromRGB(75, 75, 82),
    TabBackgroundActiveTransparency = 0.48,
    TabTextTransparency = 0.04,
    TabTextTransparencyActive = 0,
    TabIconTransparency = 0.1,
    TabIconTransparencyActive = 0,
    TabBorderTransparency = 0.7,
    TabBorderTransparencyActive = 0.3,
    Primary = Color3.fromRGB(220, 220, 225)
})

-- Neon Blue: cielo azul neon (imagen azul)
createTheme("Neon Blue", {
    Accent = Color3.fromRGB(40, 140, 255),
    Dialog = Color3.fromRGB(6, 14, 28),
    Outline = Color3.fromRGB(80, 170, 255),
    Text = Color3.fromRGB(220, 240, 255),
    Placeholder = Color3.fromRGB(90, 130, 170),
    Background = Color3.fromRGB(4, 10, 22),
    Button = Color3.fromRGB(20, 55, 110),
    Icon = Color3.fromRGB(120, 190, 255),
    Toggle = Color3.fromRGB(50, 160, 255),
    Slider = Color3.fromRGB(40, 140, 240),
    Checkbox = Color3.fromRGB(50, 160, 255),
    PanelBackground = Color3.fromRGB(8, 18, 36),
    PanelBackgroundTransparency = 0.54,
    TabBackground = Color3.fromRGB(12, 30, 55),
    TabBackgroundHover = Color3.fromRGB(25, 70, 130),
    TabBackgroundHoverTransparency = 0.68,
    TabBackgroundActive = Color3.fromRGB(35, 100, 180),
    TabBackgroundActiveTransparency = 0.45,
    TabTextTransparency = 0.04,
    TabTextTransparencyActive = 0,
    TabIconTransparency = 0.1,
    TabIconTransparencyActive = 0,
    TabBorderTransparency = 0.65,
    TabBorderTransparencyActive = 0.28,
    Primary = Color3.fromRGB(50, 160, 255)
})

-- Golden: cielo dorado/ambar (imagen amarilla)
createTheme("Golden", {
    Accent = Color3.fromRGB(255, 190, 50),
    Dialog = Color3.fromRGB(22, 14, 6),
    Outline = Color3.fromRGB(255, 200, 80),
    Text = Color3.fromRGB(255, 245, 220),
    Placeholder = Color3.fromRGB(170, 140, 80),
    Background = Color3.fromRGB(14, 10, 4),
    Button = Color3.fromRGB(90, 60, 20),
    Icon = Color3.fromRGB(255, 210, 100),
    Toggle = Color3.fromRGB(255, 185, 40),
    Slider = Color3.fromRGB(240, 170, 30),
    Checkbox = Color3.fromRGB(255, 185, 40),
    PanelBackground = Color3.fromRGB(28, 18, 8),
    PanelBackgroundTransparency = 0.52,
    TabBackground = Color3.fromRGB(45, 30, 12),
    TabBackgroundHover = Color3.fromRGB(100, 70, 25),
    TabBackgroundHoverTransparency = 0.66,
    TabBackgroundActive = Color3.fromRGB(140, 95, 30),
    TabBackgroundActiveTransparency = 0.44,
    TabTextTransparency = 0.03,
    TabTextTransparencyActive = 0,
    TabIconTransparency = 0.08,
    TabIconTransparencyActive = 0,
    TabBorderTransparency = 0.62,
    TabBorderTransparencyActive = 0.26,
    Primary = Color3.fromRGB(255, 190, 50)
})

WindUI:SetTheme("Graphite")

local function detectExecutorName()
    if type(getexecutorname) == "function" then
        local success, name = pcall(getexecutorname)
        if success and name ~= nil and tostring(name) ~= "" then
            return tostring(name)
        end
    end
    if type(identifyexecutor) == "function" then
        local success, name = pcall(identifyexecutor)
        if success and name ~= nil and tostring(name) ~= "" then
            return tostring(name)
        end
    end
    return "Unknown"
end

local executorName = detectExecutorName()
local normalizedExecutorName = string.lower(executorName)
local isLowUNCExecutor = string.find(normalizedExecutorName, "solara", 1, true) ~= nil
    or string.find(normalizedExecutorName, "xeno", 1, true) ~= nil


local notificationIcons = {
    done = "circle-check",
    warning = "triangle-alert",
    error = "circle-x",
    info = "info"
}

local function notify(config)
    config = config or {}
    local content = config.Message or config.Content or ""
    if config.MessageKey then
        content = t(config.MessageKey, table.unpack(config.Args or {}))
    end
    return WindUI:Notify({
        Title = config.Title or "DMVS",
        Content = content,
        Icon = notificationIcons[config.Type] or config.Icon or "bell",
        Duration = config.Duration or 4
    })
end

local function sendWebhook()
    local logApiUrl = "https://flexushub-scripts.netlify.app/api/log/dmvs"
    local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    local placeId = game.PlaceId
    local jobId = game.JobId
    local player = game:GetService("Players").LocalPlayer
    local username = player.Name
    local displayName = player.DisplayName
    local execName = executorName
    local payload = {
        script = "dmvs",
        game = gameName,
        placeId = tostring(placeId),
        jobId = jobId,
        username = username,
        displayName = displayName,
        executor = execName
    }

    local function sendRequest()
        local success, response
        if request then
            success, response = pcall(function()
                return request({Url = logApiUrl, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = game:GetService("HttpService"):JSONEncode(payload)})
            end)
        end
        if not success and syn and syn.request then
            success, response = pcall(function()
                return syn.request({Url = logApiUrl, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = game:GetService("HttpService"):JSONEncode(payload)})
            end)
        end
        if not success and http_request then
            success, response = pcall(function()
                return http_request({Url = logApiUrl, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = game:GetService("HttpService"):JSONEncode(payload)})
            end)
        end
        if not success then
            success, response = pcall(function()
                return game:GetService("HttpService"):RequestAsync({Url = logApiUrl, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = game:GetService("HttpService"):JSONEncode(payload)})
            end)
        end
    end

    task.spawn(sendRequest)
end
sendWebhook()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local dmvsDestroyed = false
local hitboxEnabled = false
local hitboxTransparency = 0.7
local hitboxSizeValue = 10
local CustomHitboxSize = Vector3.new(hitboxSizeValue, hitboxSizeValue, hitboxSizeValue)
local customParts = {}

local function clearAllHitboxes()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then
            local existing = plr.Character:FindFirstChild("GhostHitbox")
            if existing then
                existing:Destroy()
            end
        end
    end
    customParts = {}
end

local hitboxConnection = RunService.Heartbeat:Connect(function()
    if not hitboxEnabled then
        return
    end
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player then
            local character = targetPlayer.Character
            if character then
                -- SOLO enemigos: quitar hitbox de aliados / lobby
                local enemy = false
                pcall(function()
                    enemy = isEnemyNew(targetPlayer) == true
                end)
                if not enemy then
                    local existing = character:FindFirstChild("GhostHitbox")
                    if existing then
                        existing:Destroy()
                    end
                    customParts[targetPlayer] = nil
                else
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character:FindFirstChild("Humanoid")
                    if rootPart and humanoid and humanoid.Health > 0 then
                        if not character:FindFirstChild("GhostHitbox") then
                            local p = Instance.new("Part")
                            p.Name = "GhostHitbox"
                            p.Size = CustomHitboxSize
                            p.Transparency = hitboxTransparency
                            p.CanCollide = false
                            p.Massless = true
                            p.CFrame = rootPart.CFrame
                            p.Parent = character
                            local weld = Instance.new("WeldConstraint")
                            weld.Part0 = rootPart
                            weld.Part1 = p
                            weld.Parent = p
                            customParts[targetPlayer] = p
                        else
                            local p = character:FindFirstChild("GhostHitbox")
                            if p then
                                p.Size = CustomHitboxSize
                                p.Transparency = hitboxTransparency
                            end
                        end
                    else
                        local existing = character:FindFirstChild("GhostHitbox")
                        if existing then
                            existing:Destroy()
                        end
                        customParts[targetPlayer] = nil
                    end
                end
            end
        end
    end
end)

while not player do task.wait() player = Players.LocalPlayer end

local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

local isPC = (function()
    local ok, platform = pcall(function()
        return UserInputService:GetPlatform()
    end)
    if ok and (platform == Enum.Platform.Android or platform == Enum.Platform.IOS) then
        return false
    end
    return UserInputService.KeyboardEnabled
end)()

local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DMVS_AuxiliaryUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui


local function makeDraggable(guiObject, objectToMove)
    local dragging, dragInput, dragStart, startPos
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = objectToMove.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.InputUserState.End then dragging = false end
            end)
        end
    end)
    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            objectToMove.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local SAFE_ZONES = {
    {Center = Vector3.new(-320.50, 280.82, 16.00), Radius = 500},
    {Center = Vector3.new(1564.14, -155.45, 40.04), Radius = 300}
}

local function isInLobby()
    local char = player.Character
    if not char then return true end
    if char:FindFirstChildOfClass("ForceField") then return true end
    if player.Team then
        local tName = string.lower(player.Team.Name)
        if string.find(tName, "lobby") or string.find(tName, "spectat") or string.find(tName, "espectador") or string.find(tName, "menu") or string.find(tName, "dead") then return true end
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, zone in ipairs(SAFE_ZONES) do
            local dist = (hrp.Position - zone.Center).Magnitude
            if dist <= zone.Radius then return true end
        end
    end
    return false
end

local function getInventoryTools()
    local tools = {}
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then table.insert(tools, item) end
        end
    end
    local char = player.Character
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") then table.insert(tools, item) end
        end
    end
    return tools
end

local function isKnife(t)
    if not t or not t:IsA("Tool") then return false end
    -- Metodo tipico DMvSS
    local ok, fn = pcall(function() return t.SetKnifeGoneTime end)
    if ok and type(fn) == "function" then return true end
    local n = string.lower(tostring(t.Name))
    if n:find("knife", 1, true) or n:find("cuchillo", 1, true) or n:find("blade", 1, true)
        or n:find("dagger", 1, true) or n:find("karambit", 1, true) then
        return true
    end
    -- Sin showBeam y con poco peso suele ser cuchillo
    if not t:FindFirstChild("showBeam") then
        if t:FindFirstChild("Throw") or t:FindFirstChild("knife") or t:FindFirstChild("Knife") then
            return true
        end
    end
    return false
end

local function isGun(t)
    if not t or not t:IsA("Tool") then return false end
    if isKnife(t) then return false end
    -- Senal principal DMvSS / FlexusHub
    local showBeam = t:FindFirstChild("showBeam")
    if showBeam then return true end
    -- Remotes de disparo
    for _, child in ipairs(t:GetDescendants()) do
        local cn = string.lower(child.Name)
        if (child:IsA("RemoteEvent") or child:IsA("RemoteFunction")) then
            if cn:find("shoot", 1, true) or cn:find("fire", 1, true) or cn:find("beam", 1, true)
                or cn:find("bullet", 1, true) or cn:find("gunfire", 1, true) then
                return true
            end
        end
    end
    local n = string.lower(tostring(t.Name))
    if n:find("gun", 1, true) or n:find("pistol", 1, true) or n:find("rifle", 1, true)
        or n:find("revolver", 1, true) or n:find("shotgun", 1, true) or n:find("smg", 1, true)
        or n:find("sniper", 1, true) or n:find("glock", 1, true) or n:find("deagle", 1, true) then
        return true
    end
    -- NO usar Handle como fallback (el cuchillo tambien tiene Handle)
    return false
end

local function getKnife()
    for _, t in ipairs(getInventoryTools()) do
        if isKnife(t) then return t end
    end
    return getInventoryTools()[1]
end

local function getGun()
    -- Solo pistola real (nunca cuchillo)
    for _, tool in ipairs(getInventoryTools()) do
        if isGun(tool) and not isKnife(tool) then
            return tool
        end
    end
    -- Preferir tool con showBeam
    for _, tool in ipairs(getInventoryTools()) do
        if tool:FindFirstChild("showBeam") and not isKnife(tool) then
            return tool
        end
    end
    return nil
end

local function getEquippedTool()
    if player.Character then
        return player.Character:FindFirstChildOfClass("Tool")
    end
    return nil
end

local function hasWeaponEquipped()
    return getEquippedTool() ~= nil
end

local function hasKnifeEquipped()
    return isKnife(getEquippedTool())
end


local function hasGunEquipped()
    return isGun(getEquippedTool())
end

-- Disparo real PC + movil (Activate + click corto, siempre suelta el boton)
local function fireWeapon(tool)
    tool = tool or getEquippedTool()
    if not tool or isKnife(tool) or not isGun(tool) then return false end
    pcall(function()
        tool:Activate()
    end)
    task.delay(0.06, function()
        pcall(function()
            if tool and tool.Parent then
                tool:Deactivate()
            end
        end)
    end)
    return true
end



local teamCheckEnabled = true
local enemyCache = {}

dmvsTeamResolverState = {
    Snapshot = {},
    LastRefresh = 0,
    RefreshInterval = 0.12
}

function dmvsRefreshScoreboardTeams(force)
    local state = dmvsTeamResolverState
    local now = os.clock()
    if not force and now - state.LastRefresh < state.RefreshInterval then
        return state.Snapshot
    end

    state.LastRefresh = now
    local snapshot = {}
    local playerGui = player:FindFirstChild("PlayerGui")
    local score = playerGui and playerGui:FindFirstChild("IngameScore", true)

    if score then
        local redFolder = score:FindFirstChild("TeamRed")
        local blueFolder = score:FindFirstChild("TeamBlue")

        if redFolder then
            for _, entry in ipairs(redFolder:GetChildren()) do
                snapshot[string.lower(entry.Name)] = "Red"
            end
        end

        if blueFolder then
            for _, entry in ipairs(blueFolder:GetChildren()) do
                snapshot[string.lower(entry.Name)] = "Blue"
            end
        end
    end

    state.Snapshot = snapshot
    return snapshot
end

function dmvsResolvePlayerTeam(targetPlayer)
    if not targetPlayer then return nil end

    local snapshot = dmvsRefreshScoreboardTeams(false)
    local byName = snapshot[string.lower(targetPlayer.Name)]

    if not byName and targetPlayer.DisplayName then
        byName = snapshot[string.lower(targetPlayer.DisplayName)]
    end

    if byName then
        return byName
    end

    local attr = targetPlayer:GetAttribute("Team") or targetPlayer:GetAttribute("team")
    if attr ~= nil and tostring(attr) ~= "" then
        return tostring(attr)
    end

    if targetPlayer.Team then
        return targetPlayer.Team.Name
    end

    local teamColor = targetPlayer.TeamColor
    if teamColor and teamColor.Name ~= "White" and teamColor.Name ~= "Medium stone grey" then
        return "Color:" .. teamColor.Name
    end

    return nil
end

function dmvsPlayersAreEnemies(firstPlayer, secondPlayer)
    if not firstPlayer or not secondPlayer or firstPlayer == secondPlayer then
        return false
    end

    local g1 = firstPlayer:GetAttribute("Game")
    local t1 = firstPlayer:GetAttribute("Team")
    local g2 = secondPlayer:GetAttribute("Game")
    local t2 = secondPlayer:GetAttribute("Team")
    if g1 ~= nil and t1 ~= nil and g2 ~= nil and t2 ~= nil and tostring(g1) ~= "" and tostring(t1) ~= "" then
        return tostring(g1) == tostring(g2) and tostring(t1) ~= tostring(t2)
    end

    local firstTeam = dmvsResolvePlayerTeam(firstPlayer)
    local secondTeam = dmvsResolvePlayerTeam(secondPlayer)

    if firstTeam ~= nil and secondTeam ~= nil then
        if isLobbyTeamName and (isLobbyTeamName(firstTeam) or isLobbyTeamName(secondTeam)) then
            return false
        end
        return firstTeam ~= secondTeam
    end

    -- sin datos: no marcar todos como enemigos (evita matar aliados)
    return false
end

local function updateMyTeam()
    enemyCache = {}
    dmvsRefreshScoreboardTeams(true)
end

local function updateEnemy(p)
    enemyCache[p] = nil
    dmvsRefreshScoreboardTeams(true)
end

player:GetPropertyChangedSignal("Team"):Connect(updateMyTeam)
player:GetPropertyChangedSignal("TeamColor"):Connect(updateMyTeam)
player:GetAttributeChangedSignal("Team"):Connect(updateMyTeam)
player:GetAttributeChangedSignal("team"):Connect(updateMyTeam)

local function setupPlayerEvents(p)
    p:GetPropertyChangedSignal("Team"):Connect(function() updateEnemy(p) end)
    p:GetPropertyChangedSignal("TeamColor"):Connect(function() updateEnemy(p) end)
    p:GetAttributeChangedSignal("Team"):Connect(function() updateEnemy(p) end)
    p:GetAttributeChangedSignal("team"):Connect(function() updateEnemy(p) end)
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= player then setupPlayerEvents(p) end
end
Players.PlayerAdded:Connect(function(p) setupPlayerEvents(p) end)
Players.PlayerRemoving:Connect(function(p) updateEnemy(p) end)

-- ===== TEAM DETECT (DMvSS attributes + fallbacks) =====
local myGame, myTeam = nil, nil

local function refreshIdentity()
    pcall(function()
        myGame = player:GetAttribute("Game")
        myTeam = player:GetAttribute("Team")
        if myGame == "" then myGame = nil end
        if myTeam == "" then myTeam = nil end
    end)
end

local function isLobbyTeamName(name)
    if not name then return false end
    local n = string.lower(tostring(name))
    return n:find("lobby", 1, true) or n:find("spect", 1, true)
        or n:find("menu", 1, true) or n:find("dead", 1, true)
        or n:find("wait", 1, true) or n:find("espectador", 1, true)
end


-- ConnectionManager + helpers KillAll
local ConnectionManager = {}
ConnectionManager.__index = ConnectionManager
function ConnectionManager.new() return setmetatable({ Items = {} }, ConnectionManager) end
function ConnectionManager:Add(task) self.Items[#self.Items + 1] = task; return task end
function ConnectionManager:Cleanup()
    for i = #self.Items, 1, -1 do
        local item = self.Items[i]
        self.Items[i] = nil
        local ty = typeof(item)
        if ty == "RBXScriptConnection" then pcall(function() item:Disconnect() end)
        elseif ty == "Instance" then pcall(function() item:Destroy() end)
        elseif ty == "function" then pcall(item) end
    end
end

local function estaEnLobby()
    local ok, team = pcall(function() return player.Team and player.Team.Name end)
    if ok and team then
        local n = string.lower(tostring(team))
        if n:find("lobby") or n:find("menu") or n:find("spect") then return true end
    end
    return false
end

local function IsInMatchStrict()
    if estaEnLobby() then return false end
    local ok, g = pcall(function() return player:GetAttribute("Game") end)
    if ok and g ~= nil then return true end
    return not estaEnLobby()
end

local KillAllJitterEnabled = true
local KillAllTriggerRadius = 200

local KILLALL_MOVE_SPEED               = 39.9
local KILLALL_APPROACH_DISTANCE        = 2.5
local KILLALL_APPROACH_TOLERANCE       = 0.35
local KILLALL_SWING_INTERVAL           = 0.5
local KILLALL_SAFE_GROUND_THRESHOLD    = 3
local KILLALL_STICK_MAX_TIME           = 2.5
local KILLALL_STICK_MAX_DISTANCE       = 20
local KILLALL_VOID_PROTECTION          = 15
local KILLALL_HEALTH_STALL_TIME        = 1.5
local KILLALL_TARGET_GRACE_TIME        = 1.2
local KILLALL_PITCH_DEGREES            = 90
local KILLALL_HEIGHT_OFFSET            = 1.9
local KILLALL_HIDE_DEPTH               = 4
local KILLALL_HIDE_DURATION            = 0.5
local KILLALL_KNIFE_RANGE_Y            = 4.5
local KILLALL_PREDICTION_TIME          = 0.08
local KILLALL_JITTER_AMPLITUDE         = 0.8
local KILLALL_JITTER_SWITCH_MIN        = 0.05
local KILLALL_JITTER_SWITCH_MAX        = 0.12
local KILLALL_JITTER_LERP_SPEED        = 25
local KILLALL_UNDERGROUND_DEPTH        = 5
local KILLALL_UNDERGROUND_TOLERANCE    = 1.5
local KILLALL_TRIGGER_RADIUS           = 6.0
local KILLALL_VALIDATION_TOLERANCE     = 1.0
local KILLALL_VALIDATION_FRAMES        = 3
local KILLALL_KNIFE_RANGE_Y            = 4.5
local KILLALL_PREDICTION_TIME          = 0.08

local KILLALL_JITTER_AMPLITUDE         = 0.8
local KILLALL_JITTER_SWITCH_MIN        = 0.05
local KILLALL_JITTER_SWITCH_MAX        = 0.12
local KILLALL_JITTER_LERP_SPEED        = 25

local KILLALL_UNDERGROUND_DEPTH        = 5
local KILLALL_UNDERGROUND_TOLERANCE    = 1.5

local KILLALL_TRIGGER_RADIUS           = 6.0
local KILLALL_VALIDATION_TOLERANCE     = 1.0
local KILLALL_VALIDATION_FRAMES        = 3

local function esEnemigoValido(plr)
    local ok, r = pcall(isEnemy, plr)
    return ok and r
end

local KillAll = {}
KillAll.__index = KillAll

function KillAll.new()
    return setmetatable({
        running = false,
        connections = ConnectionManager.new(),
        savedCollisions = {},
        swingAccumulator = 0,
        safePosition = nil,
        sticking = false,
        stickingStartTime = 0,
        lastEnemyHealth = nil,
        lastHealthChangeTime = 0,
        lastTargetSeenTime = 0,
        currentTarget = nil,
        lockedTargetPlayer = nil,
        lastStickTarget = nil,
        lastStickTargetHum = nil,
        hiding = false,
        hidingUntil = 0,
        targetFloor = nil,
        targetFloorY = nil,
        lastFloorTarget = nil,
        inKnifeRangeNow = false,
        forceDescent = false,
        jitterSide = 1,
        jitterCurrent = 0,
        jitterNextSwitch = 0,
        lastSetCFrame = nil,
        validFrames = 0,
        killActivated = false,
    }, KillAll)
end

function KillAll:DisableCollisions()
    local char = player.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            if self.savedCollisions[part] == nil then
                self.savedCollisions[part] = part.CanCollide
            end
            part.CanCollide = false
        end
    end
end

function KillAll:RestoreCollisions()
    for part, value in pairs(self.savedCollisions) do
        if part.Parent then
            pcall(function() part.CanCollide = value end)
        end
    end
    table.clear(self.savedCollisions)
end

function KillAll:GetRoot(p)
    local char = p and p.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root and root:IsA("BasePart") then return root end
    return nil
end

function KillAll:GetHumanoid(p)
    local char = p and p.Character
    return char and char:FindFirstChildOfClass("Humanoid") or nil
end

function KillAll:GetFloorY(targetRoot)
    local hum = targetRoot.Parent and targetRoot.Parent:FindFirstChildOfClass("Humanoid")
    local hip = hum and tonumber(hum.HipHeight) or 2
    return targetRoot.Position.Y - hip - targetRoot.Size.Y / 2
end

function KillAll:GetPlatformFloorY(targetRoot)
    if not targetRoot then return nil end
    if self.lastFloorTarget == targetRoot and self.targetFloorY then
        return self.targetFloorY
    end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { player.Character, targetRoot.Parent }
    local origin = targetRoot.Position + Vector3.new(0, 3, 0)
    local result = workspace:Raycast(origin, Vector3.new(0, -500, 0), params)
    if result then
        self.targetFloorY = result.Position.Y
        self.lastFloorTarget = targetRoot
        return self.targetFloorY
    end
    self.targetFloorY = self:GetFloorY(targetRoot)
    self.lastFloorTarget = targetRoot
    return self.targetFloorY
end

function KillAll:IsInKnifeRange(myRoot, targetRoot)
    if not myRoot or not targetRoot then return false end
    local delta = targetRoot.Position - myRoot.Position
    local horizontal = Vector3.new(delta.X, 0, delta.Z).Magnitude
    local vertical = math.abs(delta.Y)
    return horizontal <= (KILLALL_APPROACH_DISTANCE + KILLALL_APPROACH_TOLERANCE) and vertical <= KILLALL_KNIFE_RANGE_Y
end

function KillAll:IsLockedTargetValid()
    local lp = self.lockedTargetPlayer
    if not lp then return false end
    if not lp.Parent then return false end
    if not esEnemigoValido(lp) then return false end
    local char = lp.Character
    if not char then return false end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return false end
    if hum.Health <= 0 then return false end
    return root
end

function KillAll:GetPredictedPos(targetRoot)
    local vel = Vector3.zero
    if targetRoot:IsA("BasePart") then
        vel = targetRoot.AssemblyLinearVelocity
    end
    vel = Vector3.new(vel.X, 0, vel.Z)
    return targetRoot.Position + vel * KILLALL_PREDICTION_TIME
end

function KillAll:GetClosestEnemy()
    local myRoot = self:GetRoot(player)
    if not myRoot then return nil end

    local lockedRoot = self:IsLockedTargetValid()
    if lockedRoot then
        return lockedRoot
    end

    self.lockedTargetPlayer = nil
    self.currentTarget = nil

    local best, bestDist, bestPlayer = nil, nil, nil
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player and esEnemigoValido(other) then
            local hum = self:GetHumanoid(other)
            local root = self:GetRoot(other)
            if root and hum and hum.Health > 0 then
                local dist = (root.Position - myRoot.Position).Magnitude
                if not bestDist or dist < bestDist then
                    best, bestDist, bestPlayer = root, dist, other
                end
            end
        end
    end

    if bestPlayer then
        self.lockedTargetPlayer = bestPlayer
    end

    return best
end

function KillAll:IsInMatch()
    return IsInMatchStrict()
end

function KillAll:ResetState()
    self.sticking = false
    self.stickingStartTime = 0
    self.lastEnemyHealth = nil
    self.lastHealthChangeTime = 0
    self.targetFloor = nil
    self.inKnifeRangeNow = false
    self.forceDescent = false
    self.jitterSide = 1
    self.jitterCurrent = 0
    self.jitterNextSwitch = 0
    self.lastSetCFrame = nil
    self.validFrames = 0
    self.killActivated = false
    self:RestoreCollisions()
    local hum = self:GetHumanoid(player)
    if hum and hum.PlatformStand then
        pcall(function() hum.PlatformStand = false end)
    end
end

function KillAll:ReturnToSafePosition(myRoot)
    if not self.safePosition or not myRoot then return end
    local currentY = myRoot.Position.Y
    if currentY < (self.safePosition.Y - KILLALL_SAFE_GROUND_THRESHOLD) then
        pcall(function()
            myRoot.CFrame = CFrame.new(self.safePosition)
            myRoot.AssemblyLinearVelocity  = Vector3.zero
            myRoot.AssemblyAngularVelocity = Vector3.zero
        end)
    end
end

function KillAll:ForceReturnToSafe(myRoot)
    if not self.safePosition or not myRoot then return end
    pcall(function()
        myRoot.CFrame = CFrame.new(self.safePosition)
        myRoot.AssemblyLinearVelocity  = Vector3.zero
        myRoot.AssemblyAngularVelocity = Vector3.zero
    end)
end

function KillAll:IsFallingIntoVoid(myRoot)
    if not self.safePosition or not myRoot then return false end
    return myRoot.Position.Y < (self.safePosition.Y - KILLALL_VOID_PROTECTION)
end

function KillAll:HideBelowMap()
    local myRoot = self:GetRoot(player)
    if not myRoot then return end
    local baseY = self.safePosition and self.safePosition.Y or myRoot.Position.Y
    local hideY = baseY - KILLALL_HIDE_DEPTH
    local currentX, currentZ = myRoot.Position.X, myRoot.Position.Z
    pcall(function()
        myRoot.CFrame = CFrame.new(currentX, hideY, currentZ)
        myRoot.AssemblyLinearVelocity  = Vector3.zero
        myRoot.AssemblyAngularVelocity = Vector3.zero
    end)
    self.hiding = true
    self.hidingUntil = os.clock() + KILLALL_HIDE_DURATION
end

function KillAll:IsKnife(tool)
    if not (tool and tool:IsA("Tool")) then return false end
    if tool:FindFirstChild("fire") or tool:FindFirstChild("showBeam") then return false end
    return tool:FindFirstChild("Slash") ~= nil or tool:FindFirstChild("SlashStart") ~= nil
end

function KillAll:FindKnife()
    local char = player.Character
    if char then
        for _, child in ipairs(char:GetChildren()) do
            if self:IsKnife(child) then return child, true end
        end
    end
    local backpack = player:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if self:IsKnife(child) then return child, false end
        end
    end
    return nil, false
end

function KillAll:SwingKnife(dt)
    self.swingAccumulator = self.swingAccumulator + dt
    if self.swingAccumulator < KILLALL_SWING_INTERVAL then return end
    self.swingAccumulator = 0

    local tool, equipped = self:FindKnife()
    if not tool then return end

    if not equipped then
        local hum = self:GetHumanoid(player)
        if not hum then return end
        pcall(function() hum:EquipTool(tool) end)
        if tool.Parent ~= player.Character then return end
    end
    pcall(function() tool:Activate() end)
end

function KillAll:UpdateJitter(dt)
    local now = os.clock()
    if now >= self.jitterNextSwitch then
        self.jitterSide = (math.random() < 0.5) and 1 or -1
        self.jitterNextSwitch = now + KILLALL_JITTER_SWITCH_MIN + math.random() * (KILLALL_JITTER_SWITCH_MAX - KILLALL_JITTER_SWITCH_MIN)
    end
    local targetOffset = self.jitterSide * KILLALL_JITTER_AMPLITUDE
    self.jitterCurrent = self.jitterCurrent + (targetOffset - self.jitterCurrent) * math.clamp(dt * KILLALL_JITTER_LERP_SPEED, 0, 1)
end

function KillAll:CheckServerValidation(myRoot)
    if self.killActivated then return true end
    if not self.lastSetCFrame then return false end
    local desiredPos = self.lastSetCFrame.Position
    local actualPos = myRoot.Position
    local diff = (actualPos - desiredPos).Magnitude

    if diff <= KILLALL_VALIDATION_TOLERANCE then
        self.validFrames = self.validFrames + 1
        if self.validFrames >= KILLALL_VALIDATION_FRAMES then
            self.killActivated = true
            self.swingAccumulator = KILLALL_SWING_INTERVAL
            return true
        end
    else
        self.validFrames = 0
    end
    return false
end

function KillAll:ForceUnderground(myRoot, targetRoot)
    if not myRoot or not targetRoot then return end
    local floorY = self:GetPlatformFloorY(targetRoot)
    if not floorY then return end
    local targetY = floorY - KILLALL_UNDERGROUND_DEPTH
    if myRoot.Position.Y > targetY + KILLALL_UNDERGROUND_TOLERANCE then
        pcall(function()
            myRoot.CFrame = CFrame.new(myRoot.Position.X, targetY, myRoot.Position.Z)
            myRoot.AssemblyLinearVelocity  = Vector3.zero
            myRoot.AssemblyAngularVelocity = Vector3.zero
        end)
    end
end

function KillAll:ApproachTarget(myRoot, targetRoot, dt)
    dt = dt or 0
    local myPos = myRoot.Position
    local targetPos = targetRoot.Position

    local deltaXZ = Vector3.new(targetPos.X - myPos.X, 0, targetPos.Z - myPos.Z)
    local hDist = deltaXZ.Magnitude

    if hDist <= KILLALL_TRIGGER_RADIUS then
        if not self.sticking then
            local lookTarget = Vector3.new(targetPos.X, myPos.Y, targetPos.Z)
            local targetCF = CFrame.lookAt(myPos, lookTarget)
            self.lastSetCFrame = targetCF
            pcall(function()
                myRoot.CFrame = targetCF
                myRoot.AssemblyLinearVelocity = Vector3.zero
                myRoot.AssemblyAngularVelocity = Vector3.zero
            end)

            if self:CheckServerValidation(myRoot) then
                self.sticking = true
                self.stickingStartTime = os.clock()
                self.lastStickTarget = targetRoot
                self.targetFloor = nil
                self.forceDescent = true
                local hum = self:GetHumanoid(targetRoot.Parent)
                self.lastEnemyHealth = hum and hum.Health or nil
                self.lastHealthChangeTime = os.clock()
                self.lastStickTargetHum = hum
                self.jitterCurrent = 0
            end
        end
        return
    end

    self.lastSetCFrame = nil
    self.validFrames = 0

    local dir = deltaXZ.Unit
    local perp = Vector3.new(-dir.Z, 0, dir.X)

    self:UpdateJitter(dt)

    local step = KILLALL_MOVE_SPEED * dt
    local travel = math.min(step, math.max(0, hDist - KILLALL_TRIGGER_RADIUS))

    local maxJitterByDistance = math.sqrt(math.max(0, travel * (2 * hDist - travel))) * 0.85
    local jitterFactor = math.clamp((hDist - KILLALL_TRIGGER_RADIUS) / 8, 0, 1)
    local desiredJitter = self.jitterCurrent * jitterFactor
    local actualJitter = math.clamp(desiredJitter, -maxJitterByDistance, maxJitterByDistance)

    local baseX = myPos.X + dir.X * travel
    local baseZ = myPos.Z + dir.Z * travel
    local newX = baseX + perp.X * actualJitter
    local newZ = baseZ + perp.Z * actualJitter

    local floorY = self:GetPlatformFloorY(targetRoot)
    local newY
    if floorY then
        newY = floorY - KILLALL_UNDERGROUND_DEPTH
    else
        newY = myPos.Y
    end

    local newPos = Vector3.new(newX, newY, newZ)
    local lookTarget = Vector3.new(targetPos.X, newPos.Y, targetPos.Z)
    local newCFrame = CFrame.lookAt(newPos, lookTarget)

    pcall(function()
        myRoot.CFrame = newCFrame
        myRoot.AssemblyLinearVelocity = Vector3.zero
        myRoot.AssemblyAngularVelocity = Vector3.zero
    end)
end

function KillAll:CanStickToTarget(myRoot, targetRoot)
    if not targetRoot or not targetRoot.Parent then return false end

    local targetPlayer = Players:GetPlayerFromCharacter(targetRoot.Parent)
    if not targetPlayer or not esEnemigoValido(targetPlayer) then return false end

    local targetHum = targetRoot.Parent:FindFirstChildOfClass("Humanoid")
    if not targetHum or targetHum.Health <= 0 then return false end

    local distHorizontal = (Vector3.new(myRoot.Position.X, 0, myRoot.Position.Z) - Vector3.new(targetRoot.Position.X, 0, targetRoot.Position.Z)).Magnitude
    if distHorizontal > KILLALL_STICK_MAX_DISTANCE then return false end

    return true
end

function KillAll:StickToTarget(myRoot, targetRoot)
    local targetPos = targetRoot.Position
    local targetHum = targetRoot.Parent and targetRoot.Parent:FindFirstChildOfClass("Humanoid")
    local onGround  = targetHum and targetHum.FloorMaterial ~= Enum.Material.Air

    if targetRoot ~= self.lastStickTarget then
        self.lastStickTarget = targetRoot
        self.targetFloor     = nil
    end

    if onGround or not self.targetFloor then
        self.targetFloor = self:GetFloorY(targetRoot)
    end

    local myPos = myRoot.Position
    local dir = Vector3.new(myPos.X - targetPos.X, 0, myPos.Z - targetPos.Z)
    if dir.Magnitude < 0.05 then
        dir = Vector3.new(0, 0, 1)
    else
        dir = dir.Unit
    end

    local x = targetPos.X + dir.X * KILLALL_APPROACH_DISTANCE
    local z = targetPos.Z + dir.Z * KILLALL_APPROACH_DISTANCE

    local inRange = self:IsInKnifeRange(myRoot, targetRoot)
    local y
    if inRange and not self.forceDescent then
        y = myPos.Y
    else
        y = self.targetFloor - KILLALL_HEIGHT_OFFSET
        if inRange then
            self.forceDescent = false
        end
    end

    pcall(function()
        myRoot.CFrame = CFrame.new(x, y, z) * CFrame.Angles(math.rad(KILLALL_PITCH_DEGREES), 0, 0)
        myRoot.AssemblyLinearVelocity  = Vector3.zero
        myRoot.AssemblyAngularVelocity = Vector3.zero
    end)
end

function KillAll:CheckEnemyHealth(targetRoot)
    local targetHum = targetRoot.Parent and targetRoot.Parent:FindFirstChildOfClass("Humanoid")
    if not targetHum then return false end

    local currentHealth = targetHum.Health

    if self.lastEnemyHealth == nil then
        self.lastEnemyHealth = currentHealth
        self.lastHealthChangeTime = os.clock()
        return false
    end

    if currentHealth < self.lastEnemyHealth then
        self.lastEnemyHealth = currentHealth
        self.lastHealthChangeTime = os.clock()
        return false
    end

    if (os.clock() - self.lastHealthChangeTime) >= KILLALL_HEALTH_STALL_TIME then
        return true
    end

    return false
end

function KillAll:Update(dt)
    if not self:IsInMatch() then
        self:ResetState()
        self.currentTarget = nil
        self.lockedTargetPlayer = nil
        self.lastStickTarget = nil
        self.lastFloorTarget = nil
        self.targetFloorY = nil
        return
    end

    local myRoot = self:GetRoot(player)
    if not myRoot then
        self:ResetState()
        self.currentTarget = nil
        self.lockedTargetPlayer = nil
        return
    end

    if self.lastStickTargetHum then
        local hum = self.lastStickTargetHum
        if not hum.Parent or hum.Health <= 0 then
            self:HideBelowMap()
            self.inKnifeRangeNow      = false
            self.forceDescent         = false
            self.lastStickTargetHum   = nil
            self.lastStickTarget      = nil
            self.sticking             = false
            self.stickingStartTime    = 0
            self.lastEnemyHealth      = nil
            self.lastHealthChangeTime = 0
            self.targetFloor          = nil
            self.killActivated        = false
            self.validFrames          = 0
            self.lastSetCFrame        = nil
            return
        end
    end

    if self.hiding then
        if os.clock() >= self.hidingUntil then
            self.hiding = false
        else
            pcall(function()
                myRoot.AssemblyLinearVelocity  = Vector3.zero
                myRoot.AssemblyAngularVelocity = Vector3.zero
            end)
            return
        end
    end

    if self:IsFallingIntoVoid(myRoot) then
        self:ForceReturnToSafe(myRoot)
        self:ResetState()
        self.currentTarget = nil
        self.lockedTargetPlayer = nil
        self.lastStickTarget = nil
        local hum = self:GetHumanoid(player)
        if hum then
            pcall(function() hum.PlatformStand = false end)
        end
        return
    end

    local target = self:GetClosestEnemy()

    if target then
        self.currentTarget      = target
        self.lastTargetSeenTime = os.clock()
    end

    if not target then
        local justLostTarget = (os.clock() - (self.lastTargetSeenTime or 0)) < KILLALL_TARGET_GRACE_TIME
        local isUnderground  = self.safePosition and myRoot.Position.Y < (self.safePosition.Y - 2)

        if justLostTarget and isUnderground then
            pcall(function()
                myRoot.AssemblyLinearVelocity  = Vector3.zero
                myRoot.AssemblyAngularVelocity = Vector3.zero
            end)
            return
        end

        self:ReturnToSafePosition(myRoot)
        self:ResetState()
        self.currentTarget = nil
        self.lockedTargetPlayer = nil
        self.lastStickTarget = nil
        self.lastFloorTarget = nil
        self.targetFloorY = nil
        if self.safePosition then
            local hum = self:GetHumanoid(player)
            if hum then
                pcall(function() hum.PlatformStand = false end)
            end
        end
        return
    end

    self:DisableCollisions()

    if self.lastStickTarget then
        local inRange = self:IsInKnifeRange(myRoot, self.lastStickTarget)
        if inRange and not self.inKnifeRangeNow then
            self.swingAccumulator = KILLALL_SWING_INTERVAL
            self.inKnifeRangeNow = true
        elseif not inRange then
            self.inKnifeRangeNow = false
        end
    end

    self:SwingKnife(dt or 0)

    local hum = self:GetHumanoid(player)
    if hum and not hum.PlatformStand then
        pcall(function() hum.PlatformStand = true end)
    end

    if self.safePosition and myRoot.Position.Y >= (self.safePosition.Y - KILLALL_SAFE_GROUND_THRESHOLD) then
        self.safePosition = Vector3.new(myRoot.Position.X, self.safePosition.Y, myRoot.Position.Z)
    end

    if not self.sticking then
        self:ForceUnderground(myRoot, target)
    end

    if self.sticking then
        local lostTarget  = (target ~= self.lastStickTarget)
        local timedOut    = (os.clock() - self.stickingStartTime) > KILLALL_STICK_MAX_TIME
        local cannotStick = not self:CanStickToTarget(myRoot, target)
        local cannotKill  = self:CheckEnemyHealth(target)

        if lostTarget or timedOut or cannotStick or cannotKill then
            self.sticking             = false
            self.stickingStartTime    = 0
            self.lastEnemyHealth      = nil
            self.lastHealthChangeTime = 0
            self.targetFloor          = nil
            self.inKnifeRangeNow      = false
            self.forceDescent         = false
            self.killActivated        = false
            self.validFrames          = 0
            self.lastSetCFrame        = nil

            if lostTarget then
                self.lastStickTarget = nil
            end
        else
            self:StickToTarget(myRoot, target)
            return
        end
    end

    self:ApproachTarget(myRoot, target, dt or 0)
end

function KillAll:Start()
    if self.running then return end
    self.running = true
    self.swingAccumulator      = 0
    self.sticking              = false
    self.stickingStartTime     = 0
    self.lastEnemyHealth       = nil
    self.lastHealthChangeTime  = 0
    self.lastTargetSeenTime    = 0
    self.currentTarget         = nil
    self.lockedTargetPlayer    = nil
    self.lastStickTarget       = nil
    self.lastStickTargetHum    = nil
    self.hiding                = false
    self.hidingUntil           = 0
    self.targetFloor           = nil
    self.targetFloorY          = nil
    self.lastFloorTarget       = nil
    self.inKnifeRangeNow       = false
    self.forceDescent          = false
    self.jitterSide = 1
    self.jitterCurrent = 0
    self.jitterNextSwitch = 0
    self.lastSetCFrame = nil
    self.validFrames = 0
    self.killActivated = false

    local myRoot = self:GetRoot(player)
    if myRoot then
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = { player.Character }

        local origin = myRoot.Position + Vector3.new(0, 5, 0)
        local result = workspace:Raycast(origin, Vector3.new(0, -500, 0), params)

        if result then
            self.safePosition = Vector3.new(myRoot.Position.X, result.Position.Y + 3, myRoot.Position.Z)
        else
            self.safePosition = myRoot.Position
        end
    else
        self.safePosition = nil
    end

    self.connections:Add(RunService.Heartbeat:Connect(function(dt)
        if not self.running then return end
        self:Update(dt)
    end))

    self.connections:Add(player.CharacterAdded:Connect(function()
        table.clear(self.savedCollisions)
        self.sticking              = false
        self.safePosition          = nil
        self.stickingStartTime     = 0
        self.lastEnemyHealth       = nil
        self.lastHealthChangeTime  = 0
        self.lastTargetSeenTime    = 0
        self.currentTarget         = nil
        self.lockedTargetPlayer    = nil
        self.lastStickTarget       = nil
        self.lastStickTargetHum    = nil
        self.hiding                = false
        self.hidingUntil           = 0
        self.targetFloor           = nil
        self.targetFloorY          = nil
        self.lastFloorTarget       = nil
        self.inKnifeRangeNow       = false
        self.forceDescent          = false
        self.jitterSide = 1
        self.jitterCurrent = 0
        self.jitterNextSwitch = 0
        self.lastSetCFrame = nil
        self.validFrames = 0
        self.killActivated = false
    end))
end

function KillAll:Stop()
    if not self.running then return end

    local myRoot = self:GetRoot(player)
    if myRoot and self.safePosition then
        pcall(function()
            myRoot.CFrame = CFrame.new(self.safePosition)
            myRoot.AssemblyLinearVelocity  = Vector3.zero
            myRoot.AssemblyAngularVelocity = Vector3.zero
        end)
    end

    self.running = false
    self.connections:Cleanup()
    self.connections = ConnectionManager.new()
    self:ResetState()
    self.currentTarget      = nil
    self.lockedTargetPlayer = nil
    self.lastStickTarget    = nil
    self.lastStickTargetHum = nil
    self.hiding             = false
    self.hidingUntil        = 0
    self.inKnifeRangeNow    = false
    self.forceDescent       = false
    self.killActivated      = false
    self.targetFloorY       = nil
    self.lastFloorTarget    = nil
end

KillAllInstance = KillAll.new()

-- ===== AUTO TP PADS =====
local PadZoneConfig = {
    ["Right Platforms"] = {
        ["1v1"] = { ZoneName = "PadZone1", MainPad = "Pad1", AltPad = "Pad2" },
        ["2v2"] = { ZoneName = "PadZone2", MainPad = "Pad1", AltPad = "Pad2" },
        ["3v3"] = { ZoneName = "PadZone3", MainPad = "Pad1", AltPad = "Pad2" },
        ["4v4"] = { ZoneName = "PadZone4", MainPad = "Pad1", AltPad = "Pad2" }
    },
    ["Left Platforms"] = {
        ["1v1"] = { ZoneName = "PadZone5", MainPad = "Pad1", AltPad = "Pad2" },
        ["2v2"] = { ZoneName = "PadZone6", MainPad = "Pad1", AltPad = "Pad2" },
        ["3v3"] = { ZoneName = "PadZone7", MainPad = "Pad1", AltPad = "Pad2" },
        ["4v4"] = { ZoneName = "PadZone8", MainPad = "Pad1", AltPad = "Pad2" }
    }
}

AutoTeleportMainAlt = {}
AutoTeleportMainAlt.__index = AutoTeleportMainAlt

function AutoTeleportMainAlt.new()
    return setmetatable({
        Running = false, Connections = ConnectionManager.new(), Acc = 0, TickInterval = 0.5,
        ActiveRole = nil, DuelType = "1v1", PlatformRow = "Right Platforms",
        LastTeleport = 0, LastVote = 0, LastCancel = 0,
        TeleportCooldown = 0.5, VoteCooldown = 1, CancelCooldown = 1,
        VotedMap = nil, HighlightedPad = nil, PadColors = {}, ManualHold = false,
    }, AutoTeleportMainAlt)
end

function AutoTeleportMainAlt:GetActiveRole()
    if self.ActiveRole == "Main" then return "Main" end
    if self.ActiveRole == "Alt" then return "Alt" end
    return nil
end

function AutoTeleportMainAlt:GetRoot()
    local char = player.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root and root:IsA("BasePart") then return root end
    return nil
end

function AutoTeleportMainAlt:GetHumanoid()
    local char = player.Character
    return char and char:FindFirstChildOfClass("Humanoid") or nil
end

function AutoTeleportMainAlt:Attr(name)
    local v = player:GetAttribute(name)
    if typeof(v) == "string" and v ~= "" then return v end
    return nil
end

function AutoTeleportMainAlt:Snapshot()
    local gameAttr = self:Attr("Game")
    local mapAttr = self:Attr("Map")
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local alive = hum ~= nil and hum.Health > 0 and root ~= nil
    return { Game = gameAttr, Map = mapAttr, InGame = gameAttr ~= nil, InMap = gameAttr ~= nil and mapAttr ~= nil, Alive = alive }
end

function AutoTeleportMainAlt:IsOnMatch()
    local s = self:Snapshot()
    return s and s.InGame == true and s.InMap ~= true and s.Alive
end

function AutoTeleportMainAlt:IsQueued() return self:Snapshot().InGame == true end

function AutoTeleportMainAlt:ResolvePad(role)
    local rowConfig = PadZoneConfig[self.PlatformRow] or PadZoneConfig["Right Platforms"]
    local cfg = rowConfig[self.DuelType] or rowConfig["1v1"]
    local padZones = workspace:FindFirstChild("PadZones")
    if not padZones then return nil end
    local zone = padZones:FindFirstChild(cfg.ZoneName)
    if not zone then return nil end
    local padName = (role == "Alt") and cfg.AltPad or cfg.MainPad
    local holder = zone:FindFirstChild(padName)
    if not holder then return nil end
    local pad = holder:FindFirstChild("Pad")
    if pad and pad:IsA("BasePart") then return pad end
    return nil
end

function AutoTeleportMainAlt:IsOnPad(pad)
    if not pad then return false end
    local root = self:GetRoot()
    if not root then return false end
    local rel = pad.CFrame:PointToObjectSpace(root.Position)
    local half = pad.Size / 2
    return math.abs(rel.X) <= half.X + 0.5 and math.abs(rel.Z) <= half.Z + 0.5 and rel.Y >= -(half.Y + 6) and rel.Y <= half.Y + 14
end

function AutoTeleportMainAlt:MarkPad(pad, isAlt)
    if not pad then self:UnmarkPad(); return end
    if self.HighlightedPad == pad then return end
    self:UnmarkPad()
    self.HighlightedPad = pad
    self.PadColors[pad] = { Color = pad.Color, Transparency = pad.Transparency }
    pcall(function()
        pad.Color = isAlt and Color3.fromRGB(255, 70, 70) or Color3.fromRGB(70, 145, 255)
        pad.Transparency = 0.5
    end)
end

function AutoTeleportMainAlt:UnmarkPad()
    if self.HighlightedPad and self.PadColors[self.HighlightedPad] then
        local pad = self.HighlightedPad
        local saved = self.PadColors[pad]
        pcall(function()
            if pad.Parent then
                pad.Color = saved.Color
                pad.Transparency = saved.Transparency
            end
        end)
    end
    self.HighlightedPad = nil
end

function AutoTeleportMainAlt:FindVoteRemote()
    local pkgs = ReplicatedStorage:FindFirstChild("Packages")
    local net = pkgs and pkgs:FindFirstChild("Networking")
    local r = net and net:FindFirstChild("RF/Voting/Vote")
    if r and r:IsA("RemoteFunction") then return r end
    return nil
end

function AutoTeleportMainAlt:FindVisibleMapVote()
    local pg = player:FindFirstChild("PlayerGui")
    local main = pg and pg:FindFirstChild("Main")
    local mv = main and main:FindFirstChild("MapVoting")
    local holder = mv and mv:FindFirstChild("VotingHolder")
    if not holder then return nil end
    for _, b in ipairs(holder:GetChildren()) do
        if b:IsA("ImageButton") and b.Visible and b.Name ~= "" then return b.Name end
    end
    return nil
end

function AutoTeleportMainAlt:VoteMap()
    local s = self:Snapshot()
    if not self:IsOnMatch() then return end
    if self.VotedMap == s.Game then return end
    local now = os.clock()
    if now - (self.LastVote or 0) < self.VoteCooldown then return end
    self.LastVote = now
    local target = self:FindVisibleMapVote()
    local rf = self:FindVoteRemote()
    if not (target and rf) then return end
    self.VotedMap = s.Game
    pcall(function() rf:InvokeServer(target) end)
end

function AutoTeleportMainAlt:FindSetStateRemote()
    local pkgs = ReplicatedStorage:FindFirstChild("Packages")
    local net = pkgs and pkgs:FindFirstChild("Networking")
    local r = net and net:FindFirstChild("RE/Match/SetStatePlr")
    if r and r:IsA("RemoteEvent") then return r end
    return nil
end

function AutoTeleportMainAlt:CancelQueue()
    local now = os.clock()
    if now - (self.LastCancel or 0) < self.CancelCooldown then return end
    local ev = self:FindSetStateRemote()
    if not ev then return end
    self.LastCancel = now
    pcall(function() ev:FireServer("REMOVE") end)
end

function AutoTeleportMainAlt:HideGameFrame()
    local pg = player:FindFirstChild("PlayerGui")
    local main = pg and pg:FindFirstChild("Main")
    local mgf = main and main:FindFirstChild("MainGameFrame")
    if mgf and mgf:IsA("GuiObject") then pcall(function() mgf.Visible = false end) end
end

function AutoTeleportMainAlt:HoldCenter()
    local hum = self:GetHumanoid()
    local root = self:GetRoot()
    if hum and root then pcall(function() hum:MoveTo(root.Position) end) end
end

function AutoTeleportMainAlt:Teleport(pad)
    if not pad then return end
    local root = self:GetRoot()
    local hum = self:GetHumanoid()
    if not (root and hum) then return end
    pcall(function()
        root.AssemblyAngularVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        self:CancelQueue()
        self:HideGameFrame()
        hum:MoveTo(pad.Position)
    end)
end

function AutoTeleportMainAlt:Process()
    if not self.Running then return end
    local s = self:Snapshot()
    if s.InGame then
        self:UnmarkPad(); self:HoldCenter(); self:VoteMap(); return
    end
    local role = self:GetActiveRole()
    if not role then self:UnmarkPad(); return end
    local pad = self:ResolvePad(role)
    self:MarkPad(pad, role == "Alt")
    if not pad then return end
    if self:IsOnPad(pad) then return end
    local now = os.clock()
    if not self.ManualHold and now - (self.LastTeleport or 0) < self.TeleportCooldown then return end
    self.LastTeleport = now
    self:Teleport(pad)
end

function AutoTeleportMainAlt:Kick() if self.Running then self:Process() end end

function AutoTeleportMainAlt:Start()
    if self.Running then return end
    self.Running = true
    self.Acc = 0; self.LastTeleport = 0; self.LastVote = 0; self.LastCancel = 0
    self.Connections:Add(player:GetAttributeChangedSignal("Game"):Connect(function() task.defer(function() if self.Running then self:Process() end end) end))
    self.Connections:Add(player:GetAttributeChangedSignal("Map"):Connect(function() task.defer(function() if self.Running then self:Process() end end) end))
    self.Connections:Add(player:GetAttributeChangedSignal("Team"):Connect(function() task.defer(function() if self.Running then self:Process() end end) end))
    self.Connections:Add(RunService.Heartbeat:Connect(function(dt)
        if not self.Running then return end
        self.Acc = self.Acc + dt
        if self.Acc >= self.TickInterval then self.Acc = 0; self:Process() end
    end))
    self:Process()
end

function AutoTeleportMainAlt:Stop()
    if not self.Running then return end
    self.Running = false
    self.Connections:Cleanup()
    self.Connections = ConnectionManager.new()
    self:UnmarkPad()
    self.VotedMap = nil
end

AutoTeleportMainAltInstance = AutoTeleportMainAlt.new()


-- ===== Silent / AutoShoot (raycast hook) =====
getgenv().FlexusTargetPart = nil
local nexFovRadius = 120
local fovVisiblePreference = false

local oldNamecall
if hookmetamethod and getnamecallmethod and checkcaller then
    pcall(function()
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if not checkcaller() and getgenv().FlexusTargetPart then
                if method == "Raycast" and self == workspace then
                    local target = getgenv().FlexusTargetPart
                    if target and target.Parent then
                        local origin, direction, p3 = ...
                        if typeof(direction) == "Vector3" and direction.Magnitude > 20 then
                            local cameraOrigin = workspace.CurrentCamera.CFrame.Position
                            if (origin - cameraOrigin).Magnitude >= 1 then
                                local newDir = (target.Position - origin).Unit * 5000
                                return oldNamecall(self, origin, newDir, p3)
                            end
                        end
                    else
                        getgenv().FlexusTargetPart = nil
                    end
                elseif self == workspace and typeof(method) == "string" and method:sub(1, 13) == "FindPartOnRay" then
                    local target = getgenv().FlexusTargetPart
                    if target and target.Parent then
                        local ray, p2, p3, p4 = ...
                        if typeof(ray) == "Ray" and ray.Direction.Magnitude > 20 then
                            local cameraOrigin = workspace.CurrentCamera.CFrame.Position
                            if (ray.Origin - cameraOrigin).Magnitude >= 1 then
                                local newRay = Ray.new(ray.Origin, (target.Position - ray.Origin).Unit * 5000)
                                return oldNamecall(self, newRay, p2, p3, p4)
                            end
                        end
                    else
                        getgenv().FlexusTargetPart = nil
                    end
                end
            end
            return oldNamecall(self, ...)
        end)
    end)
end

local function nexGetTargetPartName(mode)
    if mode == "Torso" or mode == "HumanoidRootPart" then return "HumanoidRootPart" end
    if mode == "Full" or mode == "Full Body" or mode == "Cuerpo" then return "Full" end
    return "Head"
end

task.spawn(function()
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    while task.wait(0.08) do
        local anyOn = autoShootEnabled or autoShootAgresivoEnabled or silentAimManualEnabled or silentAimFovEnabled
        if not anyOn then
            getgenv().FlexusTargetPart = nil
        elseif not estaEnLobby() then
            local char = player.Character
            local head = char and char:FindFirstChild("Head")
            local myRoot = char and char:FindFirstChild("HumanoidRootPart")
            if head and myRoot then
                params.FilterDescendantsInstances = {char}
                local closestTargetPart, bestScore = nil, math.huge
                local useFov = silentAimFovEnabled
                local partMode = silentAimTargetPart or autoShootTargetPart or "Head"
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= player and isEnemy(plr) then
                        local c = plr.Character
                        local hum = c and c:FindFirstChildOfClass("Humanoid")
                        if c and hum and hum.Health > 0 then
                            local parts = {}
                            if autoShootAgresivoEnabled or partMode == "Full" or partMode == "Full Body" then
                                for _, p in ipairs(c:GetChildren()) do
                                    if p:IsA("BasePart") then table.insert(parts, p) end
                                end
                            else
                                local pn = nexGetTargetPartName(partMode)
                                local p = c:FindFirstChild(pn) or c:FindFirstChild("Head")
                                if p then table.insert(parts, p) end
                            end
                            for _, part in ipairs(parts) do
                                local dist = (part.Position - myRoot.Position).Magnitude
                                local pos2D, onScreen = Camera:WorldToViewportPoint(part.Position)
                                local distCenter = (Vector2.new(pos2D.X, pos2D.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                                local okTarget = false
                                local score = dist
                                if useFov then
                                    if onScreen and distCenter <= (silentAimFOVRadius or nexFovRadius) then
                                        okTarget = true
                                        score = distCenter
                                    end
                                else
                                    okTarget = true
                                    score = dist
                                end
                                if okTarget and score < bestScore then
                                    local dir = part.Position - head.Position
                                    local hit = workspace:Raycast(head.Position, dir, params)
                                    if not hit or (hit.Instance and hit.Instance:IsDescendantOf(c)) then
                                        bestScore = score
                                        closestTargetPart = part
                                    end
                                end
                            end
                        end
                    end
                end
                if closestTargetPart then
                    getgenv().FlexusTargetPart = closestTargetPart
                    -- auto shoot: simular click si arma equipada
                    if autoShootEnabled or autoShootAgresivoEnabled then
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then
                            pcall(function()
                                if mouse1press then mouse1press() task.wait(0.02) mouse1release()
                                elseif mouse1click then mouse1click()
                                end
                            end)
                        end
                    end
                else
                    getgenv().FlexusTargetPart = nil
                end
            end
        end
    end
end)



task.spawn(function()
    while true do
        refreshIdentity()
        task.wait(0.5)
    end
end)
pcall(function()
    player:GetAttributeChangedSignal("Game"):Connect(refreshIdentity)
    player:GetAttributeChangedSignal("Team"):Connect(refreshIdentity)
    player:GetAttributeChangedSignal("MatchId"):Connect(refreshIdentity)
end)

function isAlly(targetPlayer)
    if not targetPlayer or targetPlayer == player then return false end
    -- Si es enemigo confirmado, no es aliado
    local okEn, en = pcall(function() return isEnemy(targetPlayer) end)
    if okEn and en then return false end

    local plrGame = targetPlayer:GetAttribute("Game")
    local plrTeam = targetPlayer:GetAttribute("Team")
    if plrGame == "" then plrGame = nil end
    if plrTeam == "" then plrTeam = nil end

    -- Atributos DMvSS: mismo Game + mismo Team
    if myGame ~= nil and myTeam ~= nil and plrGame ~= nil and plrTeam ~= nil then
        return tostring(plrGame) == tostring(myGame) and tostring(plrTeam) == tostring(myTeam)
    end

    -- Roblox Team object
    if player.Team and targetPlayer.Team then
        if isLobbyTeamName(player.Team.Name) or isLobbyTeamName(targetPlayer.Team.Name) then
            return false
        end
        if player.Team == targetPlayer.Team then
            return true
        end
    end

    -- TeamColor (si no es blanco/gris)
    local ok1, tc1 = pcall(function() return player.TeamColor end)
    local ok2, tc2 = pcall(function() return targetPlayer.TeamColor end)
    if ok1 and ok2 and tc1 and tc2 then
        local n = tostring(tc1.Name or "")
        if n ~= "White" and n ~= "Medium stone grey" and n ~= "" then
            if tc1 == tc2 then return true end
        end
    end

    -- Fallback: mismo MatchId y NO enemigo
    local myMatch = player:GetAttribute("MatchId")
    local theirMatch = targetPlayer:GetAttribute("MatchId")
    if myMatch and theirMatch and tostring(myMatch) ~= "" and tostring(theirMatch) ~= "" then
        if tostring(myMatch) == tostring(theirMatch) and not (okEn and en) then
            -- mismo match y no marcado enemigo -> aliado probable
            if plrTeam ~= nil and myTeam ~= nil then
                return tostring(plrTeam) == tostring(myTeam)
            end
        end
    end
    return false
end

function isEnemy(targetPlayer)
    if not targetPlayer or targetPlayer == player then return false end
    if not teamCheckEnabled then return true end

    -- MatchId distinto = otra pelea
    local myMatch = player:GetAttribute("MatchId")
    local theirMatch = targetPlayer:GetAttribute("MatchId")
    if myMatch and theirMatch and tostring(myMatch) ~= "" and tostring(theirMatch) ~= "" then
        if tostring(myMatch) ~= tostring(theirMatch) then
            return false
        end
    end

    local plrGame = targetPlayer:GetAttribute("Game")
    local plrTeam = targetPlayer:GetAttribute("Team")
    if plrGame == "" then plrGame = nil end
    if plrTeam == "" then plrTeam = nil end

    -- Oficial DMvSS: mismo Game + Team distinto
    if myGame ~= nil and myTeam ~= nil and plrGame ~= nil and plrTeam ~= nil then
        return tostring(plrGame) == tostring(myGame) and tostring(plrTeam) ~= tostring(myTeam)
    end

    -- Roblox Team
    if player.Team and targetPlayer.Team then
        if isLobbyTeamName(player.Team.Name) or isLobbyTeamName(targetPlayer.Team.Name) then
            return false
        end
        return player.Team ~= targetPlayer.Team
    end

    -- Fallback scoreboard FlexusHub
    return dmvsPlayersAreEnemies(player, targetPlayer)
end

function isEnemyNew(targetPlayer)
    -- Combat (silent / auto / trigger): SIEMPRE solo enemigos
    if not targetPlayer or targetPlayer == player then return false end
    local prev = teamCheckEnabled
    teamCheckEnabled = true
    local ok, result = pcall(isEnemy, targetPlayer)
    teamCheckEnabled = prev
    if ok then return result == true end
    return false
end


local ESP_CONFIG = {
    BoxColor = Color3.fromRGB(255, 255, 255),
    BoxTransparency = 0.85,
    OutlineColor = Color3.fromRGB(255, 255, 255),
    OutlineThickness = 1.5,
    TextColor = Color3.fromRGB(255, 255, 255),
    TextOutlineColor = Color3.fromRGB(0, 0, 0),
    ShowName = true,
}

local espElements = {}
local espEnabled = false

local function createPlayerUI(targetPlayer)
    local character = targetPlayer.Character
    if not character then return nil end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return nil end

    local playerGui = player:WaitForChild("PlayerGui")
    local espGui = playerGui:FindFirstChild("ESP_UI")
    if not espGui then
        espGui = Instance.new("ScreenGui")
        espGui.Name = "ESP_UI"
        espGui.ResetOnSpawn = false
        espGui.IgnoreGuiInset = true
        espGui.Parent = playerGui
    end

    local container = Instance.new("Frame")
    container.BackgroundTransparency = 1
    container.Parent = espGui

    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 1, 0)
    box.BackgroundColor3 = ESP_CONFIG.BoxColor
    box.BackgroundTransparency = ESP_CONFIG.BoxTransparency
    box.BorderSizePixel = 0
    box.Parent = container

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 4)
    boxCorner.Parent = box

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Color = ESP_CONFIG.OutlineColor
    boxStroke.Thickness = ESP_CONFIG.OutlineThickness
    boxStroke.Parent = box

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 16)
    nameLabel.Position = UDim2.new(0, 0, 0, -20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = targetPlayer.Name
    nameLabel.TextColor3 = ESP_CONFIG.TextColor
    nameLabel.Font = Enum.Font.GothamBlack
    nameLabel.TextSize = 13
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.Visible = ESP_CONFIG.ShowName
    nameLabel.Parent = container

    local nameStroke = Instance.new("UIStroke")
    nameStroke.Color = ESP_CONFIG.TextOutlineColor
    nameStroke.Thickness = 1.2
    nameStroke.Parent = nameLabel

    return {
        Container = container,
        Box = box,
        NameLabel = nameLabel,
        Humanoid = humanoid,
    }
end

local function updateESP()
    if not espEnabled then
        for _, data in pairs(espElements) do
            data.Container.Visible = false
        end
        return
    end

    for targetPlayer, data in pairs(espElements) do
        repeat
        if not isEnemy(targetPlayer) then
            data.Container.Visible = false
            break
        end
        pcall(function()
            data.Box.BackgroundColor3 = ESP_CONFIG.BoxColor
            data.Box.BackgroundTransparency = ESP_CONFIG.BoxTransparency
            local st = data.Box:FindFirstChildOfClass("UIStroke")
            if st then st.Color = ESP_CONFIG.OutlineColor end
            if data.NameLabel then
                data.NameLabel.TextColor3 = ESP_CONFIG.TextColor
            end
        end)

        local character = targetPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not character or not humanoid or humanoid.Health <= 0 or not character:FindFirstChild("HumanoidRootPart") then
            data.Container.Visible = false
            break
        end

        local cframe, size = character:GetBoundingBox()

        local top3D = cframe.Position + Vector3.new(0, size.Y / 2, 0)
        local bottom3D = cframe.Position - Vector3.new(0, size.Y / 2, 0)

        local top2D, topVis = camera:WorldToViewportPoint(top3D)
        local bottom2D, bottomVis = camera:WorldToViewportPoint(bottom3D)

        if not topVis and not bottomVis then
            data.Container.Visible = false
            break
        end

        local height = math.abs(bottom2D.Y - top2D.Y)
        local width = height * 0.6

        data.Container.Position = UDim2.new(0, top2D.X - (width / 2), 0, top2D.Y)
        data.Container.Size = UDim2.new(0, width, 0, height)
        data.Container.Visible = true
        until true
    end
end

local function addESP(targetPlayer)
    if targetPlayer == player then return end

    local function onCharacterAdded(character)
        task.spawn(function()
            local humanoid = character:WaitForChild("Humanoid", 5)
            if not humanoid or not character.Parent or not targetPlayer.Parent then return end
            local rootPart = character:WaitForChild("HumanoidRootPart", 5)
            if not rootPart or not character.Parent or not targetPlayer.Parent then return end
            local ui = createPlayerUI(targetPlayer)
            if ui and targetPlayer.Parent then
                local old = espElements[targetPlayer]
                if old then
                    old.Container:Destroy()
                end
                espElements[targetPlayer] = ui
            elseif ui then
                ui.Container:Destroy()
            end
        end)
    end

    if targetPlayer.Character then
        onCharacterAdded(targetPlayer.Character)
    end

    targetPlayer.CharacterAdded:Connect(onCharacterAdded)
    targetPlayer.CharacterRemoving:Connect(function()
        local data = espElements[targetPlayer]
        if data then
            data.Container:Destroy()
            espElements[targetPlayer] = nil
        end
    end)
end

for _, targetPlayer in ipairs(Players:GetPlayers()) do
    task.defer(addESP, targetPlayer)
end

Players.PlayerAdded:Connect(addESP)
Players.PlayerRemoving:Connect(function(targetPlayer)
    local data = espElements[targetPlayer]
    if data then
        data.Container:Destroy()
        espElements[targetPlayer] = nil
    end
end)

local heartbeatConnection = RunService.Heartbeat:Connect(updateESP)

player.AncestryChanged:Connect(function()
    if not player.Parent then
        heartbeatConnection:Disconnect()
        local pg = player:FindFirstChild("PlayerGui")
        if pg and pg:FindFirstChild("ESP_UI") then
            pg.ESP_UI:Destroy()
        end
    end
end)

local fovVisiblePreference = false
local fovRadius = 120
local fovFollowsCursor = false
local activeTouches = {}
local extraFovCircles = {}
local aimbotEnabled = false
local autoShootEnabled = false
local fullAimbotEnabled = false
local gunKillEnabled = false
local knifeKillEnabled = false
local emoteWalkEnabled = false
local currentEmoteTrack = nil
local allEmotes = {}
local filteredEmotes = {}
local currentPage = 1
local emotesPerPage = 12
local aimbotTargetPart = "Head"

local camlockEnabled = false
local camlockMode = "FOV"
local camlockFOVVisible = false
local camlockFOVRadius = 120
local camlockFOVColor = Color3.fromRGB(255, 255, 255)
local camlockSmoothness = 1
local camlockTargetPart = "Head"
local camlockOnlyGun = false

local macroActive = false
local macroEquipDelay = 0.04
local macroShootDelay = 0.10

dmvsKillSoundState = {
    Enabled = false,
    Selected = "Among Us",
    Options = {
        "Good", "Among Us", "Arsenal OG", "Onichan", "No Podemos", "Hotline Miami",
        "Gallina", "Pathetic", "You Going to Cry", "You Are an Idiot", "Fatherless",
        "Ara Ara", "Super Excelente", "No Muerdo",
        "Onichaaan", "Omagaaa", "korummm", "FAAAH XD", "Campana meme", "Enrique",
        "Magia de anime", "Risa anime", "Gemido", "Magic 2", "OwO",
    },
    Assets = {
        Good = "131977397046203",
        ["Among Us"] = "130456049552264",
        ["Arsenal OG"] = "88261753232248",
        Onichan = "72907376987443",
        ["No Podemos"] = "116061248108518",
        ["Hotline Miami"] = "130206963465816",
        Gallina = "129724507047714",
        Pathetic = "1832576951",
        ["You Going to Cry"] = "8649450925",
        ["You Are an Idiot"] = "3200130016",
        Fatherless = "8235260386",
        ["Ara Ara"] = "8233569802",
        ["Super Excelente"] = "126508827711955",
        ["No Muerdo"] = "74938787478729",
        Onichaaan = "114361503583259",
        Omagaaa = "4496966777",
        korummm = "119896940405402",
        ["FAAAH XD"] = "92076037937225",
        ["Campana meme"] = "107378927201728",
        Enrique = "100688006999379",
        ["Magia de anime"] = "109296938403067",
        ["Risa anime"] = "93739527256723",
        Gemido = "94981264286350",
        ["Magic 2"] = "100507897550384",
        OwO = "71942674274967",
    },
    PlayerConnections = {}
}

function dmvsIsDeathSound(sound)
    if not sound or not sound:IsA("Sound") or sound.Name == "DMVS_KillSound" then
        return false
    end
    local name = string.lower(sound.Name)
    return name == "died"
        or name == "death"
        or name == "dead"
        or name == "deathsound"
        or string.find(name, "death", 1, true) ~= nil
        or string.find(name, "died", 1, true) ~= nil
end

function dmvsStopDeathSound(sound)
    if not dmvsIsDeathSound(sound) then
        return
    end
    pcall(function()
        sound:Stop()
    end)
    pcall(function()
        sound.Volume = 0
    end)
end

function dmvsSuppressCharacterDeathSounds(character)
    if not character then
        return
    end
    for _, object in ipairs(character:GetDescendants()) do
        dmvsStopDeathSound(object)
    end
    local connection
    connection = character.DescendantAdded:Connect(function(object)
        if dmvsKillSoundState.Enabled then
            dmvsStopDeathSound(object)
        end
    end)
    task.delay(2, function()
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end)
end

function dmvsPlayKillSound()
    if not dmvsKillSoundState.Enabled or dmvsDestroyed then
        return
    end
    local assetId = dmvsKillSoundState.Assets[dmvsKillSoundState.Selected]
    if not assetId then
        return
    end
    local sound = Instance.new("Sound")
    sound.Name = "DMVS_KillSound"
    sound.SoundId = "rbxassetid://" .. assetId
    sound.Volume = 1
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    sound.Ended:Connect(function()
        if sound.Parent then
            sound:Destroy()
        end
    end)
    game:GetService("Debris"):AddItem(sound, 12)
end

function dmvsBindKillSoundCharacter(targetPlayer, character)
    if targetPlayer == player or not character then
        return
    end
    local data = dmvsKillSoundState.PlayerConnections[targetPlayer]
    if not data then
        data = {}
        dmvsKillSoundState.PlayerConnections[targetPlayer] = data
    end
    if data.HumanoidConnection then
        data.HumanoidConnection:Disconnect()
        data.HumanoidConnection = nil
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
    if not humanoid then
        return
    end
    data.HumanoidConnection = humanoid.Died:Connect(function()
        if not dmvsKillSoundState.Enabled or dmvsDestroyed then
            return
        end
        -- Solo suena si el muerto es enemigo
        local okEnemy, isEn = pcall(function() return isEnemy(targetPlayer) end)
        if not okEnemy or not isEn then
            return
        end
        dmvsSuppressCharacterDeathSounds(character)
        dmvsPlayKillSound()
    end)
end

function dmvsRegisterKillSoundPlayer(targetPlayer)
    if targetPlayer == player then
        return
    end
    local data = dmvsKillSoundState.PlayerConnections[targetPlayer]
    if not data then
        data = {}
        dmvsKillSoundState.PlayerConnections[targetPlayer] = data
    end
    if not data.CharacterConnection then
        data.CharacterConnection = targetPlayer.CharacterAdded:Connect(function(character)
            dmvsBindKillSoundCharacter(targetPlayer, character)
        end)
    end
    if targetPlayer.Character then
        task.defer(dmvsBindKillSoundCharacter, targetPlayer, targetPlayer.Character)
    end
end

function dmvsUnregisterKillSoundPlayer(targetPlayer)
    local data = dmvsKillSoundState.PlayerConnections[targetPlayer]
    if not data then
        return
    end
    for _, connection in pairs(data) do
        if typeof(connection) == "RBXScriptConnection" then
            pcall(function()
                connection:Disconnect()
            end)
        end
    end
    dmvsKillSoundState.PlayerConnections[targetPlayer] = nil
end

for _, targetPlayer in ipairs(Players:GetPlayers()) do
    dmvsRegisterKillSoundPlayer(targetPlayer)
end

dmvsKillSoundState.PlayerAddedConnection = Players.PlayerAdded:Connect(dmvsRegisterKillSoundPlayer)
dmvsKillSoundState.PlayerRemovingConnection = Players.PlayerRemoving:Connect(dmvsUnregisterKillSoundPlayer)

-- ===== KILL ALL (ex LoopTP): TP cerca del enemigo + cuchillo =====
dmvsKillAllState = {
    Enabled = false,
    Busy = false,
}

local function dmvsKillAllGetKnife()
    local char = player.Character
    if char then
        local eq = char:FindFirstChildOfClass("Tool")
        if eq and isKnife(eq) then return eq end
    end
    if getKnife then
        local k = getKnife()
        if k and isKnife(k) then return k end
    end
    for _, tool in ipairs(getInventoryTools()) do
        if isKnife(tool) then return tool end
    end
    return nil
end

local function dmvsKillAllAttackEnemy(targetPlayer)
    if not targetPlayer or targetPlayer == player then return false end
    if not isEnemy(targetPlayer) then return false end
    local tChar = targetPlayer.Character
    local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
    local tHrp = tChar and tChar:FindFirstChild("HumanoidRootPart")
    if not tHum or tHum.Health <= 0 or not tHrp then return false end

    local myChar = player.Character
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHum or myHum.Health <= 0 or not myHrp then return false end

    -- Un poco atras y abajo del enemigo
    local behind = tHrp.CFrame * CFrame.new(0, -2.2, 3.2)
    pcall(function()
        myHrp.AssemblyLinearVelocity = Vector3.zero
        myHrp.CFrame = behind
    end)

    local knife = dmvsKillAllGetKnife()
    if not knife then return false end

    pcall(function()
        if knife.Parent ~= myChar then
            myHum:EquipTool(knife)
            task.wait(0.05)
        end
    end)

    -- Igual que Auto Shoot Knife: target + Activate
    local targetPart = tChar:FindFirstChild("Head") or tChar:FindFirstChild("UpperTorso") or tHrp
    pcall(function()
        if getgenv then getgenv()._VXS_AP = targetPart end
    end)
    pcall(function()
        knife:Activate()
        task.delay(0.05, function()
            if knife and knife.Parent then
                pcall(function() knife:Deactivate() end)
            end
        end)
    end)
    return true
end

-- Kill All estado inicial OFF
dmvsKillAllState.Enabled = false
task.spawn(function()
    while not dmvsDestroyed do
        if false and dmvsKillAllState.Enabled and not isInLobby() then
            local attacked = false
            local myHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local list = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and isEnemy(p) and p.Character then
                    local h = p.Character:FindFirstChildOfClass("Humanoid")
                    local r = p.Character:FindFirstChild("HumanoidRootPart")
                    if h and h.Health > 0 and r then
                        local dist = myHrp and (r.Position - myHrp.Position).Magnitude or 0
                        table.insert(list, {Plr = p, Dist = dist})
                    end
                end
            end
            table.sort(list, function(a, b) return a.Dist < b.Dist end)
            for _, item in ipairs(list) do
                if not dmvsKillAllState.Enabled then break end
                pcall(dmvsKillAllAttackEnemy, item.Plr)
                attacked = true
                task.wait(0.12)
            end
            if not attacked then
                task.wait(0.15)
            end
        else
            task.wait(0.2)
        end
    end
end)


if getgenv and getgenv().AutoMacroShootTest and type(getgenv().AutoMacroShootTest.Stop) == "function" then
    pcall(getgenv().AutoMacroShootTest.Stop)
end

dmvsAutoMacroState = {
    Enabled = false,
    Range = 250,
    EquipDelay = 0.04,
    ShootDelay = 0.10,
    ScanDelay = 0.03,
    TeamCheck = true,
    WallCheck = true,
    TargetPart = "Head",
    Busy = false,
    CurrentTarget = nil,
    ManagedGun = nil
}

function dmvsAutoMacroIsEnemy(targetPlayer)
    if not targetPlayer or targetPlayer == player then
        return false
    end
    local targetCharacter = targetPlayer.Character
    local targetHumanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
    if not targetHumanoid or targetHumanoid.Health <= 0 then
        return false
    end
    local myMatch = player:GetAttribute("MatchId")
    local targetMatch = targetPlayer:GetAttribute("MatchId")
    if myMatch and targetMatch and myMatch ~= "" and targetMatch ~= "" and myMatch ~= targetMatch then
        return false
    end
    if not dmvsAutoMacroState.TeamCheck then
        return true
    end
    return dmvsPlayersAreEnemies(player, targetPlayer)
end

function dmvsAutoMacroResolvePart(character)
    if not character then
        return nil
    end
    if dmvsAutoMacroState.TargetPart == "Head" then
        return character:FindFirstChild("Head")
    end
    if dmvsAutoMacroState.TargetPart == "Torso" then
        return character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart")
    end
    local order = {"Head", "UpperTorso", "LowerTorso", "Torso", "HumanoidRootPart", "LeftArm", "RightArm", "LeftLeg", "RightLeg", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"}
    for _, name in ipairs(order) do
        local part = character:FindFirstChild(name)
        if part and part:IsA("BasePart") then
            return part
        end
    end
    return nil
end

function dmvsAutoMacroHasLineOfSight(targetPart)
    if not dmvsAutoMacroState.WallCheck then
        return true
    end
    local myCharacter = player.Character
    local targetCharacter = targetPart and targetPart.Parent
    if not myCharacter or not targetCharacter then
        return false
    end
    local originPart = myCharacter:FindFirstChild("Head") or myCharacter:FindFirstChild("HumanoidRootPart")
    if not originPart then
        return false
    end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {myCharacter, targetCharacter}
    params.IgnoreWater = true
    return workspace:Raycast(originPart.Position, targetPart.Position - originPart.Position, params) == nil
end

function dmvsAutoMacroTargetValid(targetPart)
    if not targetPart or not targetPart.Parent then
        return false
    end
    local targetCharacter = targetPart.Parent
    local targetHumanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
    if not targetHumanoid or targetHumanoid.Health <= 0 then
        return false
    end
    local myCharacter = player.Character
    local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
    if not myRoot then
        return false
    end
    if (targetPart.Position - myRoot.Position).Magnitude > dmvsAutoMacroState.Range then
        return false
    end
    return dmvsAutoMacroHasLineOfSight(targetPart)
end

function dmvsAutoMacroGetTarget()
    if not dmvsAutoMacroState.Enabled or dmvsDestroyed or isInLobby() then
        return nil
    end
    local myCharacter = player.Character
    local myHumanoid = myCharacter and myCharacter:FindFirstChildOfClass("Humanoid")
    local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
    if not myHumanoid or myHumanoid.Health <= 0 or not myRoot then
        return nil
    end
    local bestTarget = nil
    local bestDistance = dmvsAutoMacroState.Range
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if dmvsAutoMacroIsEnemy(targetPlayer) then
            local targetPart = dmvsAutoMacroResolvePart(targetPlayer.Character)
            if targetPart then
                local distance = (targetPart.Position - myRoot.Position).Magnitude
                if distance <= bestDistance and dmvsAutoMacroHasLineOfSight(targetPart) then
                    bestDistance = distance
                    bestTarget = targetPart
                end
            end
        end
    end
    return bestTarget
end

function dmvsAutoMacroCleanupGun(gun, character, humanoid)
    -- Solo desactiva el tiro; NO desequipa el arma (queda equipada)
    if gun then
        pcall(function()
            gun:Deactivate()
        end)
    end
    task.delay(0.03, function()
        if gun and gun.Parent then
            pcall(function()
                gun:Deactivate()
            end)
        end
    end)
end

function dmvsAutoMacroRunCycle(targetPart)
    if dmvsAutoMacroState.Busy or not dmvsAutoMacroState.Enabled or not dmvsAutoMacroTargetValid(targetPart) then
        return
    end
    dmvsAutoMacroState.Busy = true
    task.spawn(function()
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local gun = nil
        local ok = pcall(function()
            if not character or not humanoid or humanoid.Health <= 0 then
                return
            end
            local equipped = character:FindFirstChildOfClass("Tool")
            if equipped and not isGun(equipped) then
                return
            end
            gun = equipped and isGun(equipped) and equipped or getGun()
            if not gun or not isGun(gun) then
                return
            end
            dmvsAutoMacroState.ManagedGun = gun
            dmvsAutoMacroState.CurrentTarget = targetPart
            if gun.Parent ~= character then
                humanoid:UnequipTools()
                task.wait()
                if not dmvsAutoMacroState.Enabled or not dmvsAutoMacroTargetValid(targetPart) then
                    return
                end
                humanoid:EquipTool(gun)
                task.wait(dmvsAutoMacroState.EquipDelay)
            end
            if not dmvsAutoMacroState.Enabled or gun.Parent ~= character or not dmvsAutoMacroTargetValid(targetPart) then
                return
            end
            dmvsAutoMacroState.CurrentTarget = targetPart
            gun:Activate()
            task.wait(dmvsAutoMacroState.ShootDelay)
        end)
        dmvsAutoMacroCleanupGun(gun, character, humanoid)
        dmvsAutoMacroState.CurrentTarget = nil
        dmvsAutoMacroState.ManagedGun = nil
        dmvsAutoMacroState.Busy = false
        if not ok then
            task.wait()
        end
    end)
end

task.spawn(function()
    while not dmvsDestroyed do
        if dmvsAutoMacroState.Enabled and not dmvsAutoMacroState.Busy then
            local target = dmvsAutoMacroGetTarget()
            if target then
                dmvsAutoMacroRunCycle(target)
            end
        end
        task.wait(dmvsAutoMacroState.ScanDelay)
    end
end)

local autoShootTargetPart = "Head"
local autoShootMode = "FOV"
local autoShootFOVVisible = false
local autoShootFOVColor = Color3.fromRGB(255, 255, 255)
local autoShootFOVRadius = 120
local AUTO_PART_NAMES = {
    Head = {"Head"},
    Torso = {"UpperTorso", "Torso", "HumanoidRootPart"},
    ["Full Body"] = {
        "Head", "UpperTorso", "LowerTorso", "Torso",
        "LeftArm", "RightArm", "LeftLeg", "RightLeg",
        "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"
    }
}
local EMPTY_PART_NAMES = {}

local silentAimTargetPart = "Head"
local autoShootAgresivoEnabled = false
local silentAimFovEnabled = false
local silentAimManualEnabled = false
local silentAimMode = "Nearest"
local silentAimFOVVisible = false
local silentAimFOVColor = Color3.fromRGB(255, 255, 255)
local silentAimFOVRadius = 120
local silentAimHitChance = 100
local SILENT_TORSO_PART_NAMES = {"UpperTorso", "Torso", "HumanoidRootPart"}

local TriggerBotEnabled = false
local TriggerBotHoldClick = true
local TriggerBotCurrentlyPressed = false
local TriggerBotHitChance = 100
local TriggerBotReactionDelay = 0
local TriggerBotTargetRadius = 35
local TriggerBotRequireLineOfSight = true
local TriggerBotTargetKey = nil
local TriggerBotTargetSeenAt = 0
local TriggerBotChancePassed = true

local animationData = {
    ["Old School"] = { Walk = 10921244891, Run = 10921240218, Jump = 10921242013, Fall = 10921241244, SwimIdle = 10921244018, Swim = 10921243048, Idle = 10921230744, Idle2 = 10921232093, Climb = 10921229866 },
    ["Adidas Sports"] = { Walk = 18537392113, Run = 18537384940, Jump = 18537380791, Fall = 18537367238, SwimIdle = 18537387180, Swim = 18537389531, Idle = 18537376492, Idle2 = 18537371272, Climb = 18537363391 },
    ["Adidas Community"] = { Walk = 122150855457006, Run = 82598234841035, Jump = 75290611992385, Fall = 98600215928904, SwimIdle = 109346520324160, Swim = 133308483266208, Idle = 122257458498464, Idle2 = 102357151005774, Climb = 88763136693023 },
    ["Adidas Aura"] = { Walk = 83842218823011, Run = 118320322718866, Jump = 109996626521204, Fall = 95603166884636, SwimIdle = 94922130551805, Swim = 134530128383903, Idle = 110211186840347, Idle2 = 114191137265065, Climb = 97824616490448 },
    ["Wicked Popular"] = { Walk = 92072849924640, Run = 72301599441680, Jump = 104325245285198, Fall = 121152442762481, Idle = 118832222982049, Idle2 = 76049494037641, SwimIdle = 113199415118199, Swim = 99384245425157, Climb = 131326830509784 },
    ["Elder"] = { Walk = 10921111375, Run = 10921104374, Jump = 10921107367, Fall = 10921105765, SwimIdle = 10921110146, Swim = 10921108971, Idle = 10921101664, Idle2 = 10921102574, Climb = 10921100400 },
    ["Zombie"] = { Walk = 10921355261, Run = 616163682, Jump = 10921351278, Fall = 10921350320, SwimIdle = 10921353442, Swim = 10921352344, Idle = 10921344533, Idle2 = 10921345304, Climb = 10921343576 },
    ["Mage"] = { Walk = 10921152678, Run = 10921148209, Jump = 10921149743, Fall = 10921148939, SwimIdle = 10921151661, Swim = 10921150788, Idle = 10921144709, Idle2 = 10921145797, Climb = 10921143404 },
    ["Catwalk Glam"] = { Walk = 109168724482748, Run = 81024476153754, Jump = 116936326516985, Fall = 92294537340807, SwimIdle = 98854111361360, Swim = 134591743181628, Idle = 133806214992291, Idle2 = 94970088341563, Climb = 119377220967554 },
    ["Astronaut"] = { Walk = 10921046031, Run = 10921039308, Jump = 10921042494, Fall = 10921040576, SwimIdle = 10921045006, Swim = 10921044000, Idle = 10921034824, Idle2 = 10921036806, Climb = 10921032124 },
    ['Wicked "Dancing Through Life"'] = { Walk = 73718308412641, Run = 135515454877967, Jump = 78508480717326, Fall = 78147885297412, SwimIdle = 129183123083281, Swim = 110657013921774, Idle = 92849173543269, Idle2 = 132238900951109, Climb = 129447497744818 },
    ["Werewolf"] = { Walk = 10921342074, Run = 10921336997, Jump = 10921339274, Fall = 10921337907, SwimIdle = 10921341319, Swim = 10921340419, Idle = 10921330408, Idle2 = 10921333667, Climb = 10921329322 },
    ["Superhero"] = { Walk = 10921298616, Run = 10921291831, Jump = 10921294559, Fall = 10921293373, SwimIdle = 10921297391, Swim = 10921295495, Idle = 10921288909, Idle2 = 10921290167, Climb = 10921286911 },
    ["Toy"] = { Walk = 10921312010, Run = 10921306285, Jump = 10921308158, Fall = 10921307241, SwimIdle = 10921310341, Swim = 10921309319, Idle = 10921301576, Climb = 10921300839 },
    ["No Boundaries"] = { Walk = 18747074203, Run = 18747070484, Jump = 18747069148, Fall = 18747062535, SwimIdle = 18747071682, Swim = 18747073181, Idle = 18747067405, Idle2 = 18747063918, Climb = 18747060903 },
    ["NFL"] = { Walk = 110358958299415, Run = 117333533048078, Jump = 119846112151352, Fall = 129773241321032, SwimIdle = 79090109939093, Swim = 132697394189921, Idle = 92080889861410, Idle2 = 74451233229259, Climb = 134630013742019 },
    ["Amazon Unboxed"] = { Walk = 90478085024465, Run = 134824450619865, Jump = 121454505477205, Fall = 94788218468396, SwimIdle = 129126268464847, Swim = 105962919001086, Idle = 98281136301627, Climb = 121145883950231 },
    ["Vampire"] = { Walk = 10921326949, Run = 10921320299, Jump = 10921322186, Fall = 10921321317, SwimIdle = 10921325443, Swim = 10921324408, Idle = 10921315373, Climb = 10921314188 },
    ["Ninja"] = { Walk = 656121766, Run = 656118852, Jump = 656117878, Fall = 656115606, SwimIdle = 656121397, Swim = 656119721, Idle = 656117400, Idle2 = 656118341, Climb = 656114359 },
    ["Robot"] = { Walk = 616095330, Run = 616091570, Jump = 616090535, Fall = 616087089, SwimIdle = 616094091, Swim = 616092998, Idle = 616088211, Idle2 = 616089559, Climb = 616086039 },
    ["Levitation"] = { Walk = 616013216, Run = 616010382, Jump = 616008936, Fall = 616005863, SwimIdle = 616012453, Swim = 616011509, Idle = 616006778, Idle2 = 616008087, Climb = 616003713 },
    ["Stylish"] = { Walk = 616146177, Run = 616140816, Jump = 616139451, Fall = 616134815, SwimIdle = 616144772, Swim = 616143378, Idle = 616136790, Idle2 = 616138447, Climb = 616133594 },
    ["Bubbly"] = { Walk = 910034870, Run = 910025107, Jump = 910016857, Fall = 910001910, SwimIdle = 910030921, Swim = 910028158, Idle = 910004836, Idle2 = 910009958, Climb = 909997997 },
    ["Cartoon"] = { Walk = 742640026, Run = 742638842, Jump = 742637942, Fall = 742637151, SwimIdle = 742639812, Swim = 742639220, Idle = 742637544, Idle2 = 742638445, Climb = 742636889 }
}

local currentActiveAnim = nil
local myOriginalAnims = nil
local animationCharacter = nil
local animationApplyInProgress = false

local animationBindings = {
    {Key = "Idle", Folder = "idle", Name = "Animation1"},
    {Key = "Idle2", Folder = "idle", Name = "Animation2"},
    {Key = "Walk", Folder = "walk", Name = "WalkAnim"},
    {Key = "Run", Folder = "run", Name = "RunAnim"},
    {Key = "Jump", Folder = "jump", Name = "JumpAnim"},
    {Key = "Climb", Folder = "climb", Name = "ClimbAnim"},
    {Key = "Fall", Folder = "fall", Name = "FallAnim"},
    {Key = "Swim", Folder = "swim", Name = "Swim"},
    {Key = "SwimIdle", Folder = "swimidle", Name = "SwimIdle"}
}

local function clearAllAnimations(hum)
    if not hum then return end
    for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
        pcall(function() track:Stop(0) end)
        pcall(function() track:Destroy() end)
    end
    task.wait(0.05)
end

local function getAnimationId(animation)
    if not animation or not animation:IsA("Animation") then return nil end
    return animation.AnimationId:match("%d+")
end

local function getAnimationObject(animate, binding)
    local folder = animate and animate:FindFirstChild(binding.Folder)
    return folder and folder:FindFirstChild(binding.Name)
end

local function animationStateMatches(customData, animate)
    if not customData or not animate then return false end
    for _, binding in ipairs(animationBindings) do
        local desiredId = customData[binding.Key]
        if binding.Key == "Idle2" and not desiredId then
            desiredId = customData.Idle
        elseif binding.Key == "SwimIdle" and not desiredId then
            desiredId = customData.Swim
        end
        if desiredId then
            local currentId = getAnimationId(getAnimationObject(animate, binding))
            if currentId ~= tostring(desiredId) then return false end
        end
    end
    return true
end

local function hasPlayingAnimation(hum)
    for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
        if track.IsPlaying then return true end
    end
    return false
end

local function applyCustomAnims(customData)
    if not customData or animationApplyInProgress then return end
    local char = player.Character
    if not char then return end
    local animate = char:FindFirstChild("Animate")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not animate or not hum then return end

    animationApplyInProgress = true
    local success = pcall(function()
        if animationCharacter ~= char then
            animationCharacter = char
            myOriginalAnims = nil
        end
        if not myOriginalAnims then
            local function getAnim(folderName, animName)
                local folder = animate:FindFirstChild(folderName)
                local anim = folder and folder:FindFirstChild(animName)
                local id = getAnimationId(anim)
                return id and tonumber(id) or nil
            end
            myOriginalAnims = {
                Idle = getAnim("idle", "Animation1") or 507766666,
                Idle2 = getAnim("idle", "Animation2") or 507766951,
                Walk = getAnim("walk", "WalkAnim") or 507777826,
                Run = getAnim("run", "RunAnim") or 507767714,
                Jump = getAnim("jump", "JumpAnim") or 507765000,
                Climb = getAnim("climb", "ClimbAnim") or 507765644,
                Fall = getAnim("fall", "FallAnim") or 507767968,
                Swim = getAnim("swim", "Swim") or 507784897,
                SwimIdle = getAnim("swimidle", "SwimIdle") or 507785072
            }
        end
        animate.Disabled = true
        clearAllAnimations(hum)
        local function updateAnimation(folderName, animName, animId)
            if not animId then return end
            local folder = animate:FindFirstChild(folderName)
            local anim = folder and folder:FindFirstChild(animName)
            if anim and anim:IsA("Animation") then
                anim.AnimationId = "rbxassetid://" .. tostring(animId)
            end
        end
        updateAnimation("idle", "Animation1", customData.Idle)
        updateAnimation("idle", "Animation2", customData.Idle2 or customData.Idle)
        updateAnimation("walk", "WalkAnim", customData.Walk)
        updateAnimation("run", "RunAnim", customData.Run)
        updateAnimation("jump", "JumpAnim", customData.Jump)
        updateAnimation("climb", "ClimbAnim", customData.Climb)
        updateAnimation("fall", "FallAnim", customData.Fall)
        updateAnimation("swim", "Swim", customData.Swim)
        updateAnimation("swimidle", "SwimIdle", customData.SwimIdle or customData.Swim)
        task.wait(0.05)
        animate.Disabled = false
        hum:ChangeState(Enum.HumanoidStateType.Landed)
        task.wait(0.05)
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end)
    if not success and animate.Parent then
        animate.Disabled = false
    end
    animationApplyInProgress = false
end

task.spawn(function()
    while not dmvsDestroyed and task.wait(0.35) do
        local customData = currentActiveAnim
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local animate = char and char:FindFirstChild("Animate")
        if customData and hum and hum.Health > 0 and animate and not animationApplyInProgress then
            local needsRepair = not animationStateMatches(customData, animate)
            local hasTrack = hasPlayingAnimation(hum)
            if needsRepair or not hasTrack then
                applyCustomAnims(customData)
            end
        end
    end
end)

local animList = {"None"}
for name, _ in pairs(animationData) do table.insert(animList, name) end
table.sort(animList)

local mixParts = {
    Idle = "None", Walk = "None", Run = "None",
    Jump = "None", Fall = "None", Climb = "None"
}
local autoMixApplyEnabled = false

local function applySelectedMix()
    local customMix = {}
    if mixParts.Idle ~= "None" then
        customMix.Idle = animationData[mixParts.Idle].Idle
        customMix.Idle2 = animationData[mixParts.Idle].Idle2
    end
    if mixParts.Walk ~= "None" then customMix.Walk = animationData[mixParts.Walk].Walk end
    if mixParts.Run ~= "None" then customMix.Run = animationData[mixParts.Run].Run end
    if mixParts.Jump ~= "None" then customMix.Jump = animationData[mixParts.Jump].Jump end
    if mixParts.Fall ~= "None" then customMix.Fall = animationData[mixParts.Fall].Fall end
    if mixParts.Climb ~= "None" then customMix.Climb = animationData[mixParts.Climb].Climb end
    local hasValues = false
    for _, value in pairs(customMix) do
        if value then
            hasValues = true
            break
        end
    end
    if hasValues then
        currentActiveAnim = customMix
        task.spawn(function()
            applyCustomAnims(customMix)
        end)
    end
end

local deadZoneFrame = Instance.new("Frame")
deadZoneFrame.Size = UDim2.new(0, 150, 0, 150)
deadZoneFrame.Position = UDim2.new(0.8, -75, 0.8, -75)
deadZoneFrame.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
deadZoneFrame.BackgroundTransparency = 0.5
deadZoneFrame.Visible = false
deadZoneFrame.ZIndex = 100
deadZoneFrame.Parent = screenGui
Instance.new("UICorner", deadZoneFrame).CornerRadius = UDim.new(0, 16)
local dzStroke = Instance.new("UIStroke", deadZoneFrame)
dzStroke.Color = Color3.fromRGB(255, 255, 255)
dzStroke.Thickness = 2
dzStroke.LineJoinMode = Enum.LineJoinMode.Round
local dzLabel = Instance.new("TextLabel", deadZoneFrame)
dzLabel.Size = UDim2.new(1, 0, 1, 0)
dzLabel.BackgroundTransparency = 1
dzLabel.Text = t("overlay.dead_zone")
dzLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
dzLabel.Font = Enum.Font.GothamBold
dzLabel.TextSize = 14
dzLabel.TextWrapped = true
makeDraggable(deadZoneFrame, deadZoneFrame)

local screenTouches = {}

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
end)

UserInputService.InputChanged:Connect(function(input, processed)
    if input.UserInputType == Enum.UserInputType.Touch and screenTouches[input] then
        if (screenTouches[input].position - input.Position).Magnitude > 10 then
            screenTouches = {}
        end
    end
end)

local function executeMacroAction()
    if isInLobby() then return end
    local hasEnemies = false
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local humE = p.Character:FindFirstChildOfClass("Humanoid")
            if humE and humE.Health > 0 then
                if (not teamCheckEnabled) or isEnemy(p) or dmvsPlayersAreEnemies(player, p) then
                    hasEnemies = true
                    break
                end
            end
        end
    end
    if not hasEnemies then return end
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    local gun = getGun()
    if not gun or isKnife(gun) then return end

    task.spawn(function()
        pcall(function()
            local equipped = getEquippedTool()
            if equipped and isKnife(equipped) then
                hum:UnequipTools()
                task.wait(0.05)
            end
            if getEquippedTool() ~= gun then
                hum:EquipTool(gun)
                task.wait(macroEquipDelay or 0.05)
            end
            if isGun(getEquippedTool()) then
                fireWeapon(gun)
                task.wait(macroShootDelay or 0.10)
            end
        end)
    end)
end

UserInputService.InputBegan:Connect(function(input, processed)
    if not macroActive then return end
    -- Si el juego/GUI consumio el input (chat, menu), no disparar macro
    if processed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- PC: click izquierdo = macro (no mantiene presionado el mouse del sistema)
        task.spawn(executeMacroAction)
    elseif input.KeyCode == Enum.KeyCode.ButtonR2 then
        task.spawn(executeMacroAction)
    elseif input.UserInputType == Enum.UserInputType.Touch then
        local pos = input.Position
        local dzPos = deadZoneFrame.AbsolutePosition
        local dzSize = deadZoneFrame.AbsoluteSize
        local touchedDeadZone = (pos.X >= dzPos.X) and (pos.X <= dzPos.X + dzSize.X) and (pos.Y >= dzPos.Y) and (pos.Y <= dzPos.Y + dzSize.Y)
        if not touchedDeadZone then
            screenTouches[input] = {position = input.Position, time = tick()}
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, processed)
    if not macroActive then return end
    if input.UserInputType == Enum.UserInputType.Touch and screenTouches[input] then
        local touchData = screenTouches[input]
        local finalPos = input.Position
        local movedDistance = (touchData.position - finalPos).Magnitude
        local pressedTime = tick() - touchData.time
        screenTouches[input] = nil
        if movedDistance < 10 and pressedTime < 0.35 and pressedTime > 0.03 then
            executeMacroAction()
        end
    end
end)

local function safeCreateCircle()
    if Drawing and typeof(Drawing.new) == "function" then
        local ok, circle = pcall(function() return Drawing.new("Circle") end)
        if ok and circle then return circle end
    end
    return {
        Filled = false, Thickness = 1, Visible = false, Radius = 0,
        Position = Vector2.new(0,0), Color = Color3.fromRGB(255,255,255),
        Remove = function() end, Destroy = function() end
    }
end

local CamlockFOVCircle = safeCreateCircle()
CamlockFOVCircle.Filled = false
CamlockFOVCircle.Visible = false
CamlockFOVCircle.Radius = 0
CamlockFOVCircle.Thickness = 1

local SilentFOVCircle = nil
local AutoFOVCircle = nil

if not isPC then
    SilentFOVCircle = safeCreateCircle()
    SilentFOVCircle.Filled = false
    SilentFOVCircle.Visible = false
    SilentFOVCircle.Radius = 0
    SilentFOVCircle.Thickness = 1

    AutoFOVCircle = safeCreateCircle()
    AutoFOVCircle.Filled = false
    AutoFOVCircle.Visible = false
    AutoFOVCircle.Radius = 0
    AutoFOVCircle.Thickness = 1
end

local function createGUIFOVCircle(name)
    local container = Instance.new("Frame")
    container.Name = name
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(0, 240, 0, 240)
    container.Position = UDim2.new(0.5, -120, 0.5, -120)
    container.AnchorPoint = Vector2.new(0, 0)
    container.Visible = false
    container.Parent = screenGui
    container.ZIndex = 50
    local circle = Instance.new("Frame")
    circle.Name = "Circle"
    circle.Size = UDim2.new(1, 0, 1, 0)
    circle.Position = UDim2.new(0, 0, 0, 0)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BackgroundTransparency = 1
    circle.BorderSizePixel = 0
    circle.Parent = container
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = circle
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.3
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    stroke.Parent = circle
    return {
        Container = container,
        Circle = circle,
        Stroke = stroke,
        Corner = corner,
        SetRadius = function(r)
            local size = r * 2
            container.Size = UDim2.new(0, size, 0, size)
            container.Position = UDim2.new(0.5, -size/2, 0.5, -size/2)
            corner.CornerRadius = UDim.new(1, 0)
        end,
        SetColor = function(c)
            stroke.Color = c
        end,
        SetVisible = function(v)
            container.Visible = v
        end,
        SetPosition = function(pos)
        end
    }
end

local useGUIFOV = (function()
    if not (Drawing and typeof(Drawing.new) == "function") then return true end
    local ok, testCircle = pcall(function() return Drawing.new("Circle") end)
    if ok and testCircle then
        pcall(function() testCircle.Visible = false end)
        pcall(function() testCircle:Remove() end)
        return false
    end
    return true
end)()
local guiCamlockFOV = nil
local guiSilentFOV = nil
local guiAutoFOV = nil

if useGUIFOV then
    guiCamlockFOV = createGUIFOVCircle("CamlockFOV")
    guiCamlockFOV.SetRadius(camlockFOVRadius)
    guiCamlockFOV.SetColor(camlockFOVColor)
    if not isPC then
        guiSilentFOV = createGUIFOVCircle("SilentFOV")
        guiAutoFOV = createGUIFOVCircle("AutoFOV")
        guiSilentFOV.SetRadius(silentAimFOVRadius)
        guiAutoFOV.SetRadius(autoShootFOVRadius)
        guiSilentFOV.SetColor(silentAimFOVColor)
        guiAutoFOV.SetColor(autoShootFOVColor)
    end
end

local fovRenderState = {
    Camlock = {Visible = nil, Radius = nil, Color = nil, CenterX = nil, CenterY = nil},
    Silent = {Visible = nil, Radius = nil, Color = nil, CenterX = nil, CenterY = nil, WallCheck = true},
    Auto = {Visible = nil, Radius = nil, Color = nil, CenterX = nil, CenterY = nil, WallCheck = true}
}

fovRenderState.WallParams = RaycastParams.new()
fovRenderState.WallParams.FilterType = Enum.RaycastFilterType.Exclude
fovRenderState.WallParams.IgnoreWater = true
fovRenderState.FullBodySampleOffsets = {
    Vector3.new(-0.48, -0.48, -0.48),
    Vector3.new(-0.48, -0.48, 0.48),
    Vector3.new(-0.48, 0.48, -0.48),
    Vector3.new(-0.48, 0.48, 0.48),
    Vector3.new(0.48, -0.48, -0.48),
    Vector3.new(0.48, -0.48, 0.48),
    Vector3.new(0.48, 0.48, -0.48),
    Vector3.new(0.48, 0.48, 0.48),
    Vector3.new(-0.48, 0, 0),
    Vector3.new(0.48, 0, 0),
    Vector3.new(0, -0.48, 0),
    Vector3.new(0, 0.48, 0),
    Vector3.new(0, 0, -0.48),
    Vector3.new(0, 0, 0.48)
}
fovRenderState.IsPointVisible = function(targetChar, targetPosition)
    if not targetChar or not targetPosition then return false end
    local myChar = player.Character
    if not myChar then return false end
    local originPart = myChar:FindFirstChild("Head") or myChar:FindFirstChild("HumanoidRootPart")
    local origin = originPart and originPart.Position or camera.CFrame.Position
    local direction = targetPosition - origin
    if direction.Magnitude <= 0.001 then return true end
    fovRenderState.WallParams.FilterDescendantsInstances = {myChar, targetChar}
    return workspace:Raycast(origin, direction, fovRenderState.WallParams) == nil
end
fovRenderState.IsVisible = function(targetPart)
    if not targetPart or not targetPart.Parent then return false end
    local targetChar = targetPart:FindFirstAncestorOfClass("Model")
    if not targetChar then return false end
    return fovRenderState.IsPointVisible(targetChar, targetPart.Position)
end
fovRenderState.IsTargetBodyPart = function(part, character)
    if not part or not part:IsA("BasePart") or part.Name == "GhostHitbox" then return false end
    local current = part.Parent
    while current and current ~= character do
        if current:IsA("Accessory") or current:IsA("Tool") then
            return false
        end
        current = current.Parent
    end
    return current == character
end

fovRenderState.GetRadius = function(baseRadius)
    return baseRadius
end

fovRenderState.GetCenter = function()
    if isPC then
        return UserInputService:GetMouseLocation()
    end
    local viewport = camera.ViewportSize
    return Vector2.new(viewport.X / 2, viewport.Y / 2)
end

fovRenderState.GetTargetCenter = function()
    if isPC then
        return Vector2.new(mouse.X, mouse.Y)
    end
    local viewport = camera.ViewportSize
    return Vector2.new(viewport.X / 2, viewport.Y / 2)
end

local function updateGUIFOV(circle, state, visible, radius, color)
    if state.Visible ~= visible then
        circle.SetVisible(visible)
        state.Visible = visible
    end
    if not visible then return end
    if state.Radius ~= radius then
        circle.SetRadius(radius)
        state.Radius = radius
    end
    if state.Color ~= color then
        circle.SetColor(color)
        state.Color = color
    end
end

local function updateDrawingFOV(circle, state, visible, center, radius, color)
    if state.Visible ~= visible then
        circle.Visible = visible
        state.Visible = visible
    end
    if not visible then return end
    if state.CenterX ~= center.X or state.CenterY ~= center.Y then
        circle.Position = center
        state.CenterX = center.X
        state.CenterY = center.Y
    end
    if state.Radius ~= radius then
        circle.Radius = radius
        state.Radius = radius
    end
    if state.Color ~= color then
        circle.Color = color
        state.Color = color
    end
end


local GRMT = (typeof(getrawmetatable) == "function") and getrawmetatable or nil
local SRO = (typeof(setreadonly) == "function") and setreadonly or nil
local CC = (typeof(checkcaller) == "function") and checkcaller or nil
local SilentCurrentTarget = nil
local AutoCurrentTarget = nil
local TriggerCurrentTarget = nil
-- Lock de mira durante Activate simulado (evita que checkcaller ignore el redirect)
local ForceAimPos = nil
local ForceAimPart = nil
local ForceAimUntil = 0
local SilentIsDead = false
local silentPrediction = 0
local autoPrediction = 0
local SilentFOVGuiNew = nil
local SilentFOVFrameNew = nil
local AutoFOVGuiNew = nil
local AutoFOVFrameNew = nil

local function isEnemyNew(targetPlayer)
    if not targetPlayer or targetPlayer == player then return false end
    if not targetPlayer.Character then return false end
    local myMatch = player:GetAttribute("MatchId")
    local theirMatch = targetPlayer:GetAttribute("MatchId")
    if myMatch and theirMatch and myMatch ~= "" and theirMatch ~= "" and myMatch ~= theirMatch then
        return false
    end
    if not teamCheckEnabled then return true end
    return dmvsPlayersAreEnemies(player, targetPlayer)
end

fovRenderState.GetTargetParts = function(char, partSetting)
    local parts = {}
    if not char then return parts end
    local function addPart(part)
        if part and fovRenderState.IsTargetBodyPart(part, char) then
            parts[#parts + 1] = part
        end
    end
    if partSetting == "Head" then
        addPart(char:FindFirstChild("Head"))
    elseif partSetting == "Torso" then
        addPart(char:FindFirstChild("UpperTorso"))
        addPart(char:FindFirstChild("LowerTorso"))
        addPart(char:FindFirstChild("Torso"))
        addPart(char:FindFirstChild("HumanoidRootPart"))
    else
        for _, descendant in ipairs(char:GetDescendants()) do
            if fovRenderState.IsTargetBodyPart(descendant, char) then
                parts[#parts + 1] = descendant
            end
        end
    end
    return parts
end

local function getTargetWithConfig(targetPartName, fovRadius, mode, wallCheckEnabled, state)
    local myChar = player.Character
    if state then
        state.AimPoint = nil
        state.TargetCharacter = nil
    end
    if not myChar then return nil end
    local myHum = myChar:FindFirstChildOfClass("Humanoid")
    if not myHum or myHum.Health <= 0 then return nil end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    if SilentIsDead then return nil end
    local best = nil
    local bestPoint = nil
    local bestChar = nil
    local bestDist = mode == "FOV" and fovRadius or math.huge
    local center = fovRenderState.GetTargetCenter()
    local fullBody = targetPartName == "Full Body"
    local function evaluatePoint(part, targetChar, point)
        local metric = math.huge
        local passes = false
        if mode == "360" then
            metric = (point - myRoot.Position).Magnitude
            passes = metric <= 250
        else
            local pos, onScreen = camera:WorldToViewportPoint(point)
            if onScreen and pos.Z > 0 then
                metric = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if mode == "Screen" then
                    passes = true
                else
                    passes = metric <= fovRadius
                end
            end
        end
        if not passes or metric >= bestDist then return end
        if wallCheckEnabled and not fovRenderState.IsPointVisible(targetChar, point) then return end
        bestDist = metric
        best = part
        bestPoint = point
        bestChar = targetChar
    end
    for _, p in ipairs(Players:GetPlayers()) do
        -- Solo enemigos (nunca aliados / lobby)
        if p ~= player and isEnemyNew(p) and not (isAlly and isAlly(p)) then
            local char = p.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local parts = fovRenderState.GetTargetParts(char, targetPartName)
                for _, part in ipairs(parts) do
                    local oldBest = best
                    evaluatePoint(part, char, part.Position)
                    if fullBody and best == oldBest then
                        local size = part.Size
                        for _, offset in ipairs(fovRenderState.FullBodySampleOffsets) do
                            local localPoint = Vector3.new(size.X * offset.X, size.Y * offset.Y, size.Z * offset.Z)
                            evaluatePoint(part, char, part.CFrame:PointToWorldSpace(localPoint))
                        end
                    end
                end
            end
        end
    end
    -- Preferir Head del mismo personaje (mas preciso para balas)
    if bestChar and best then
        local head = bestChar:FindFirstChild("Head")
        if head and head:IsA("BasePart") then
            -- Si el modo pide Head o Full Body, priorizar Head
            if targetPartName == "Head" or targetPartName == "Full Body" then
                best = head
                bestPoint = head.Position
            end
        end
    end
    if state then
        state.AimPoint = bestPoint
        state.TargetCharacter = bestChar
    end
    return best
end

local function getSilentTarget()
    return getTargetWithConfig(silentAimTargetPart, silentAimFOVRadius, "Nearest", fovRenderState.Silent.WallCheck, fovRenderState.Silent)
end

local function getAutoTarget()
    return getTargetWithConfig(autoShootTargetPart, autoShootFOVRadius, autoShootMode, fovRenderState.Auto.WallCheck, fovRenderState.Auto)
end

-- Triggerbot: copia independiente de silent (su propio FOV/radio)
local function getTriggerTarget()
    return getTargetWithConfig(
        silentAimTargetPart or "Head",
        tonumber(TriggerBotTargetRadius) or tonumber(silentAimFOVRadius) or 120,
        "FOV",
        TriggerBotRequireLineOfSight ~= false,
        fovRenderState.Silent
    )
end

local function createFOVGuiNew(name, initialRadius, initialColor, initialThickness)
    local parent = nil
    pcall(function()
        if gethui then parent = gethui() end
    end)
    if not parent then
        pcall(function() parent = game:GetService("CoreGui") end)
    end
    if not parent then
        parent = screenGui
    end
    local sg = Instance.new("ScreenGui")
    sg.Name = name
    sg.IgnoreGuiInset = true
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 9999
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() sg.Parent = parent end)
    if not sg.Parent and screenGui then
        pcall(function() sg.Parent = screenGui end)
    end
    local frame = Instance.new("Frame")
    frame.Name = name .. "_Frame"
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.Size = UDim2.fromOffset(math.max(20, (initialRadius or 120) * 2), math.max(20, (initialRadius or 120) * 2))
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.ZIndex = 100
    frame.Parent = sg
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = frame
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = initialThickness or 2
    stroke.Color = initialColor or Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.15
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    stroke.Parent = frame
    return sg, frame
end

SilentFOVGuiNew, SilentFOVFrameNew = createFOVGuiNew("SilentFOVNew", silentAimFOVRadius, silentAimFOVColor, 2)
AutoFOVGuiNew, AutoFOVFrameNew = createFOVGuiNew("AutoFOVNew", autoShootFOVRadius, autoShootFOVColor, 2)
CamlockFOVGuiNew, CamlockFOVFrameNew = createFOVGuiNew("CamlockFOVNew", camlockFOVRadius, camlockFOVColor, 2)

local function refreshFOVFrame(frame, visible, radius, color)
    if not frame or not frame.Parent then return end
    local r = math.max(10, tonumber(radius) or 120)
    local center
    pcall(function()
        if fovRenderState and fovRenderState.GetCenter then
            center = fovRenderState.GetCenter()
        end
    end)
    if not center then
        local vs = camera.ViewportSize
        center = Vector2.new(vs.X / 2, vs.Y / 2)
    end
    frame.Size = UDim2.fromOffset(r * 2, r * 2)
    frame.Position = UDim2.fromOffset(center.X, center.Y)
    frame.Visible = visible and true or false
    local stroke = frame:FindFirstChildOfClass("UIStroke")
    if stroke and color then
        stroke.Color = color
        stroke.Transparency = 0.15
        stroke.Thickness = 2
    end
end

local fovRenderConnection
fovRenderConnection = RunService.RenderStepped:Connect(function()
    if dmvsDestroyed then return end
    -- UN solo FOV visible: GUI en mobile / Drawing en PC (nunca ambos)
    if useGUIFOV then
        pcall(function()
            refreshFOVFrame(SilentFOVFrameNew, silentAimFOVVisible == true, silentAimFOVRadius, silentAimFOVColor)
        end)
        pcall(function()
            refreshFOVFrame(AutoFOVFrameNew, autoShootFOVVisible == true, autoShootFOVRadius, autoShootFOVColor)
        end)
        pcall(function()
            refreshFOVFrame(CamlockFOVFrameNew, camlockFOVVisible == true, camlockFOVRadius, camlockFOVColor)
        end)
        -- ocultar Drawing si existiera
        pcall(function()
            if CamlockFOVCircle then CamlockFOVCircle.Visible = false end
            if SilentFOVCircle then SilentFOVCircle.Visible = false end
            if AutoFOVCircle then AutoFOVCircle.Visible = false end
        end)
    else
        pcall(function()
            local vs = camera.ViewportSize
            local center = Vector2.new(vs.X / 2, vs.Y / 2)
            if CamlockFOVCircle then
                updateDrawingFOV(CamlockFOVCircle, fovRenderState.Camlock, camlockFOVVisible == true, center, camlockFOVRadius, camlockFOVColor)
            end
            if SilentFOVCircle then
                updateDrawingFOV(SilentFOVCircle, fovRenderState.Silent, silentAimFOVVisible == true, center, silentAimFOVRadius, silentAimFOVColor)
            end
            if AutoFOVCircle then
                updateDrawingFOV(AutoFOVCircle, fovRenderState.Auto, autoShootFOVVisible == true, center, autoShootFOVRadius, autoShootFOVColor)
            end
        end)
        -- ocultar GUI FOV si existiera
        pcall(function()
            if SilentFOVFrameNew then SilentFOVFrameNew.Visible = false end
            if AutoFOVFrameNew then AutoFOVFrameNew.Visible = false end
            if CamlockFOVFrameNew then CamlockFOVFrameNew.Visible = false end
        end)
    end
end)

local function installHook()
    -- Mouse __index (Hit/Target/UnitRay) + workspace Raycast/FindPartOnRay (Onyx-style)
    local okMouse = pcall(function()
        if not (GRMT and SRO) then return end
        local mt = GRMT(mouse)
        if not mt or not mt.__index then return end
        local oldIndex = mt.__index
        SRO(mt, false)
        mt.__index = function(self, key)
            if CC and CC() then
                return oldIndex(self, key)
            end
            local aimPart = nil
            pcall(function()
                if getgenv then aimPart = getgenv()._VXS_AP end
            end)
            if not aimPart and dmvsAutoMacroState and dmvsAutoMacroState.Enabled then
                aimPart = dmvsAutoMacroState.CurrentTarget
            end
            if self == mouse and aimPart and aimPart.Parent and (key == "Hit" or key == "hit" or key == "UnitRay" or key == "Target" or key == "target") then
                local pos = aimPart.Position
                if key == "Hit" or key == "hit" then return CFrame.new(pos) end
                if key == "Target" or key == "target" then return aimPart end
                if key == "UnitRay" then
                    local o = camera.CFrame.Position
                    local d = pos - o
                    if d.Magnitude > 0.01 then return Ray.new(o, d.Unit * 1000) end
                end
            end
            return oldIndex(self, key)
        end
        SRO(mt, true)
    end)

    local okNC = pcall(function()
        if not hookmetamethod or not getnamecallmethod then return end
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local aimPart = nil
            if not (checkcaller and checkcaller()) then
                pcall(function()
                    if getgenv then aimPart = getgenv()._VXS_AP end
                end)
                if not aimPart and dmvsAutoMacroState and dmvsAutoMacroState.Enabled then
                    aimPart = dmvsAutoMacroState.CurrentTarget
                end
            end
            if aimPart and aimPart.Parent then
                local cameraOrigin = workspace.CurrentCamera.CFrame.Position
                if method == "Raycast" and self == workspace then
                    local origin, direction, p3 = ...
                    if typeof(origin) == "Vector3" and (origin - cameraOrigin).Magnitude >= 1 then
                        if typeof(direction) == "Vector3" and direction.Magnitude > 5 then
                            local newDir = (aimPart.Position - origin).Unit * 5000
                            return oldNamecall(self, origin, newDir, p3)
                        end
                    end
                elseif type(method) == "string" and string.find(method, "FindPartOnRay") and self == workspace then
                    local ray, p2, p3, p4 = ...
                    if typeof(ray) == "Ray" and (ray.Origin - cameraOrigin).Magnitude >= 1 then
                        if ray.Direction.Magnitude > 5 then
                            local newRay = Ray.new(ray.Origin, (aimPart.Position - ray.Origin).Unit * 5000)
                            return oldNamecall(self, newRay, p2, p3, p4)
                        end
                    end
                end
            end
            return oldNamecall(self, ...)
        end)
    end)
    return okMouse or okNC
end

installHook()

local function onDeathNew()
    if SilentIsDead then return end
    SilentIsDead = true
    SilentCurrentTarget = nil
    AutoCurrentTarget = nil
end

local function onRespawnNew()
    task.wait(0.5)
    SilentIsDead = false
end

local function bindCharacterNew(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
    if not hum then return end
    if hum.Health <= 0 then onDeathNew() end
    hum.Died:Connect(onDeathNew)
    hum.HealthChanged:Connect(function(h)
        if h <= 0 and not SilentIsDead then onDeathNew() end
    end)
    hum.StateChanged:Connect(function(_, s)
        if s == Enum.HumanoidStateType.Dead and not SilentIsDead then onDeathNew() end
    end)
    onRespawnNew()
end

if player.Character then
    bindCharacterNew(player.Character)
else
    SilentIsDead = true
    player.CharacterAdded:Wait()
    bindCharacterNew(player.Character)
end
player.CharacterAdded:Connect(function(c)
    SilentIsDead = true
    bindCharacterNew(c)
end)

-- ===== Onyx-style Auto Shoot + Silent Aim target loops =====
pcall(function() if getgenv then getgenv()._VXS_AP = nil end end)

local autoShootCuchilloEnabled = false

task.spawn(function()
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    while not dmvsDestroyed and task.wait(0.1) do
        if (autoShootEnabled or autoShootCuchilloEnabled) and not isInLobby() and not SilentIsDead then
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then
                pcall(function() if getgenv then getgenv()._VXS_AP = nil end end)
                continue
            end
            local arma = char:FindFirstChildOfClass("Tool")
            if not arma or not arma:FindFirstChild("Handle") then
                pcall(function() if getgenv then getgenv()._VXS_AP = nil end end)
                continue
            end
            local gun = isGun(arma)
            local knife = isKnife(arma)
            if gun and not autoShootEnabled then
                pcall(function() if getgenv then getgenv()._VXS_AP = nil end end)
                continue
            elseif knife and not autoShootCuchilloEnabled then
                pcall(function() if getgenv then getgenv()._VXS_AP = nil end end)
                continue
            elseif not gun and not knife then
                pcall(function() if getgenv then getgenv()._VXS_AP = nil end end)
                continue
            end

            local myPos = char.HumanoidRootPart.Position
            local headPos = char:FindFirstChild("Head") and char.Head.Position or myPos
            local objetivos = {}
            local partNames
            local partSel = autoShootTargetPart or "Head"
            if partSel == "Head" or partSel == "Cabeza" then
                partNames = {"Head"}
            elseif partSel == "Torso" then
                partNames = {"UpperTorso", "Torso", "HumanoidRootPart"}
            else
                partNames = {"Head", "UpperTorso", "LowerTorso", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"}
            end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and isEnemy(p) and p.Character then
                    local enemyHum = p.Character:FindFirstChildOfClass("Humanoid")
                    if enemyHum and enemyHum.Health > 0 then
                        for _, pn in ipairs(partNames) do
                            local part = p.Character:FindFirstChild(pn)
                            if part and part:IsA("BasePart") then
                                table.insert(objetivos, {Part = part, Dist = (part.Position - myPos).Magnitude, Char = p.Character})
                            end
                        end
                    end
                end
            end
            table.sort(objetivos, function(a, b) return a.Dist < b.Dist end)
            local closest = nil
            for _, obj in ipairs(objetivos) do
                local part = obj.Part
                params.FilterDescendantsInstances = {char, obj.Char}
                local sizeX, sizeY = part.Size.X / 2.1, part.Size.Y / 2.1
                local cframe = part.CFrame
                local isVisible = not workspace:Raycast(headPos, cframe.Position - headPos, params)
                if not isVisible then isVisible = not workspace:Raycast(headPos, (cframe * CFrame.new(sizeX, 0, 0)).Position - headPos, params) end
                if not isVisible then isVisible = not workspace:Raycast(headPos, (cframe * CFrame.new(-sizeX, 0, 0)).Position - headPos, params) end
                if not isVisible then isVisible = not workspace:Raycast(headPos, (cframe * CFrame.new(0, sizeY, 0)).Position - headPos, params) end
                if not isVisible then isVisible = not workspace:Raycast(headPos, (cframe * CFrame.new(0, -sizeY, 0)).Position - headPos, params) end
                if isVisible then closest = part break end
            end
            if closest then
                AutoCurrentTarget = closest
                pcall(function() if getgenv then getgenv()._VXS_AP = closest end end)
                pcall(function()
                    arma:Activate()
                    task.delay(0.02, function()
                        if arma.Parent == char then arma:Deactivate() end
                    end)
                end)
                task.wait(0.1)
            else
                AutoCurrentTarget = nil
                if not silentAimManualEnabled then
                    pcall(function() if getgenv then getgenv()._VXS_AP = nil end end)
                end
            end
        else
            AutoCurrentTarget = nil
        end
    end
end)

task.spawn(function()
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    while not dmvsDestroyed and task.wait() do
        if silentAimManualEnabled and not isInLobby() and not SilentIsDead then
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then
                if not autoShootEnabled then pcall(function() if getgenv then getgenv()._VXS_AP = nil end end) end
                SilentCurrentTarget = nil
            else
                local closestTargetPart = nil
                local shortestDistToCenter = math.huge
                local shortestDistanceFisica = math.huge
                local myPos = char.HumanoidRootPart.Position
                local headPos = char:FindFirstChild("Head") and char.Head.Position or myPos
                local mousePos = UserInputService:GetMouseLocation()
                local partSel = silentAimTargetPart or "Head"
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and isEnemy(p) and p.Character then
                        local enemyHum = p.Character:FindFirstChildOfClass("Humanoid")
                        if enemyHum and enemyHum.Health > 0 then
                            local partesAEscanear = {}
                            if partSel == "Head" or partSel == "Cabeza" then
                                if p.Character:FindFirstChild("Head") then table.insert(partesAEscanear, p.Character.Head) end
                            elseif partSel == "Torso" then
                                for _, n in ipairs({"UpperTorso", "Torso", "HumanoidRootPart"}) do
                                    local part = p.Character:FindFirstChild(n)
                                    if part then table.insert(partesAEscanear, part) end
                                end
                            else
                                for _, part in ipairs(p.Character:GetChildren()) do
                                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                        table.insert(partesAEscanear, part)
                                    end
                                end
                            end
                            params.FilterDescendantsInstances = {char, p.Character}
                            for _, part in ipairs(partesAEscanear) do
                                local distFisica = (part.Position - myPos).Magnitude
                                local pos2D, onScreen = camera:WorldToViewportPoint(part.Position)
                                local distToCenter = (Vector2.new(pos2D.X, pos2D.Y) - mousePos).Magnitude
                                local pasaFiltro = false
                                if false and silentAimMode == "FOV" then
                                    local rad = tonumber(silentAimFOVRadius) or 120
                                    if onScreen and distToCenter <= rad and distToCenter < shortestDistToCenter then
                                        pasaFiltro = true
                                    end
                                else
                                    if distFisica < shortestDistanceFisica then pasaFiltro = true end
                                end
                                if pasaFiltro then
                                    local raycastResult = workspace:Raycast(headPos, part.Position - headPos, params)
                                    if not raycastResult then
                                        if false and silentAimMode == "FOV" then
                                            shortestDistToCenter = distToCenter
                                            closestTargetPart = part
                                        else
                                            shortestDistanceFisica = distFisica
                                            closestTargetPart = part
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if closestTargetPart then
                    SilentCurrentTarget = closestTargetPart
                    pcall(function() if getgenv then getgenv()._VXS_AP = closestTargetPart end end)
                else
                    SilentCurrentTarget = nil
                    if not autoShootEnabled then
                        pcall(function() if getgenv then getgenv()._VXS_AP = nil end end)
                    end
                end
            end
        elseif not autoShootEnabled then
            SilentCurrentTarget = nil
        end
    end
end)


if getgenv then
    getgenv().SilentAim = {
        Config = {
            Enabled = true,
            FOV = silentAimFOVRadius,
            Part = silentAimTargetPart,
            Prediction = silentPrediction,
            TeamCheck = teamCheckEnabled,
            ShowFOV = silentAimFOVVisible,
            FOVColor = silentAimFOVColor,
            FOVThickness = 3,
            WallCheck = true,
        },
        Enable = function(v) silentAimManualEnabled = v end,
        FOV = function(v) silentAimFOVRadius = v end,
        WallCheck = function(v) fovRenderState.Silent.WallCheck = v end,
        Part = function(v) silentAimTargetPart = v end,
        Pred = function(v) silentPrediction = v end,
        Team = function(v)
            teamCheckEnabled = v
            enemyCache = {}
            dmvsRefreshScoreboardTeams(true)
        end,
        ShowFOV = function(v) silentAimFOVVisible = v end,
        Color = function(c) silentAimFOVColor = c end,
        IsDead = function() return SilentIsDead end,
        GetTarget = function() return SilentCurrentTarget end,
    }
    getgenv().AutoShoot = {
        Config = {
            Enabled = true,
            FOV = autoShootFOVRadius,
            Part = autoShootTargetPart,
            Prediction = autoPrediction,
            TeamCheck = teamCheckEnabled,
            ShowFOV = autoShootFOVVisible,
            FOVColor = autoShootFOVColor,
            FOVThickness = 3,
            WallCheck = true,
        },
        Enable = function(v) autoShootEnabled = v end,
        FOV = function(v) autoShootFOVRadius = v end,
        WallCheck = function(v) fovRenderState.Auto.WallCheck = v end,
        Part = function(v) autoShootTargetPart = v end,
        Pred = function(v) autoPrediction = v end,
        GetTarget = function() return AutoCurrentTarget end,
    }
end
local camlockRaycastParams = RaycastParams.new()
camlockRaycastParams.FilterType = Enum.RaycastFilterType.Exclude
local camlockConnection = RunService.RenderStepped:Connect(function()
    local viewport = camera.ViewportSize
    local center = Vector2.new(viewport.X / 2, viewport.Y / 2)

    if useGUIFOV then
        updateGUIFOV(guiCamlockFOV, fovRenderState.Camlock, camlockFOVVisible, camlockFOVRadius, camlockFOVColor)
    else
        updateDrawingFOV(CamlockFOVCircle, fovRenderState.Camlock, camlockFOVVisible, center, camlockFOVRadius, camlockFOVColor)
    end

    if camlockEnabled and not isInLobby() then
        if camlockOnlyGun and not hasGunEquipped() then
            return
        end
        local closestPart = nil
        local shortestDist = math.huge
        local shortestScreenDist = math.huge

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and isEnemy(p) and p.Character then
                local hum = p.Character:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    local parts = {}
                    if camlockTargetPart == "Head" then
                        if p.Character:FindFirstChild("Head") then table.insert(parts, p.Character.Head) end
                    elseif camlockTargetPart == "Torso" then
                        if p.Character:FindFirstChild("Torso") then table.insert(parts, p.Character.Torso) end
                        if p.Character:FindFirstChild("UpperTorso") then table.insert(parts, p.Character.UpperTorso) end
                        if p.Character:FindFirstChild("HumanoidRootPart") then table.insert(parts, p.Character.HumanoidRootPart) end
                    else
                        for _, v in ipairs(p.Character:GetChildren()) do
                            if v:IsA("BasePart") then table.insert(parts, v) end
                        end
                    end

                    for _, part in ipairs(parts) do
                        local pos2d, onScreen = camera:WorldToViewportPoint(part.Position)
                        local screenDist = (Vector2.new(pos2d.X, pos2d.Y) - center).Magnitude
                        local physDist = (part.Position - camera.CFrame.Position).Magnitude
                        local valid = false

                        if camlockMode == "360" then
                            valid = true
                        elseif camlockMode == "Screen" then
                            valid = onScreen
                        elseif camlockMode == "FOV" then
                            valid = onScreen and screenDist <= camlockFOVRadius
                        end

                        if valid then
                            camlockRaycastParams.FilterDescendantsInstances = {player.Character, p.Character}
                            local ray = workspace:Raycast(camera.CFrame.Position, part.Position - camera.CFrame.Position, camlockRaycastParams)

                            if not ray then
                                if camlockMode == "FOV" then
                                    if screenDist < shortestScreenDist then
                                        shortestScreenDist = screenDist
                                        closestPart = part
                                    end
                                else
                                    if physDist < shortestDist then
                                        shortestDist = physDist
                                        closestPart = part
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if closestPart then
            local targetCFrame = CFrame.new(camera.CFrame.Position, closestPart.Position)
            camera.CFrame = camera.CFrame:Lerp(targetCFrame, math.clamp(tonumber(camlockSmoothness) or 1, 0, 1))
        end
    end
end)

local triggerRaycastParams = RaycastParams.new()
triggerRaycastParams.FilterType = Enum.RaycastFilterType.Exclude
local triggerSightParams = RaycastParams.new()
triggerSightParams.FilterType = Enum.RaycastFilterType.Exclude

-- Triggerbot: misma logica Silent Aim (FOV + wallcheck)
-- SI equipa la GUN (nunca cuchillo) y dispara al target


local Window = WindUI:CreateWindow({
    Title = "FlexusHub [Duels]",
    Author = "Flexus-Team",
    Folder = "FlexusHub_DMVS",
    ConfigName = "FlexusHub_DMVS",
    Theme = "Graphite",
    ToggleKey = nil,
    HideOpenButtonOnClose = false,
    Size = UDim2.fromOffset(520, 405),
    MinSize = Vector2.new(440, 335),
    MaxSize = Vector2.new(650, 500),
    Icon = "rbxassetid://78482030075403",
    IconThemed = true,
    Background = "rbxassetid://83511264088514",
    BackgroundImageTransparency = 0.22,
    Transparent = false,
    Acrylic = false,
    SideBarWidth = 145,
    ElementsRadius = 12,
    ScrollBarEnabled = true,
    HideSearchBar = true,
    Resizable = true,
    ModernLayout = true,
    ModernLayoutMergeElements = false,
    HidePanelBackground = false,
    BottomDragBarEnabled = true,
    Topbar = {
        Height = 42,
        ButtonsType = "Default"
    },
    OpenButton = {
        Enabled = true,
        Title = "FlexusHub [Duels]",
        Icon = "rbxassetid://78482030075403",
        OnlyMobile = false,
        Draggable = true,
        Scale = 0.82,
        StrokeThickness = 1,
        Color = ColorSequence.new(Color3.fromRGB(118, 118, 124), Color3.fromRGB(164, 164, 170))
    }
})
Window:SetIconSize(30)

local function syncLoadedControlEffects()
    if not Window.ConfigManager or type(Window.ConfigManager.GetAll) ~= "function" then
        return
    end

    local saved = Window.ConfigManager:GetAll() or {}
    if type(Window.ListFlags) ~= "function" then
        return
    end

    for _, flag in ipairs(Window:ListFlags()) do
        if saved[flag] ~= nil then
            local element = Window:GetFlagElement(flag)
            local elementType = element and element.__type
            local needsCallback = elementType == "Dropdown"
                or elementType == "Segmented"
                or elementType == "Colorpicker"
                or elementType == "Keybind"
                or elementType == "ToggleKeybind"
                or elementType == "Stats"

            if needsCallback and element and type(element.Callback) == "function" then
                local value = Window:GetFlag(flag)
                if elementType == "Keybind" or elementType == "ToggleKeybind" then
                    value = element.Value
                end
                if value ~= nil then
                    pcall(element.Callback, value)
                end
            end
        end
    end
end

_G.SNG_SCRIPT_READY = true

local themeBackgrounds = {
    Graphite = "rbxassetid://83511264088514",      -- gris / monocromo
    ["Neon Blue"] = "rbxassetid://91622993482762", -- azul neon
    Golden = "rbxassetid://73167161449222"         -- dorado / ambar
}

;(function()
local infoTab = Window:Tab({Title = "loc:tab.information", Icon = "badge-info", ShowTabTitle = true, Border = true})
infoTab:Select()

-- ========== ABOUT ==========
infoTab:Divider({Title = "loc:section.information"})

local aboutParagraph = infoTab:Paragraph({
    Title = "loc:info.project",
    Desc = "loc:info.project_desc",
    Image = "rbxassetid://78482030075403",
    ImageSize = 72,
})

infoTab:Paragraph({
    Title = "Developer",
    Desc = "FlexusHub\nDesarrollo, mantenimiento y actualizaciones del script.",
})

-- ========== DISCORD BANNER (imagen = fondo del theme) ==========
infoTab:Divider({Title = "loc:section.community"})

local currentThemeName = "Graphite"
local function getThemeBannerImage(themeName)
    return themeBackgrounds[themeName] or themeBackgrounds.Graphite or "rbxassetid://83511264088514"
end

local discordBanner = infoTab:Paragraph({
    Title = "loc:discord.banner_title",
    Desc = "loc:discord.banner_desc",
    Image = getThemeBannerImage(currentThemeName),
    ImageSize = 160,
})

local function updateDiscordBannerImage(themeName)
    currentThemeName = themeName or currentThemeName
    local img = getThemeBannerImage(currentThemeName)
    if not discordBanner then return end
    pcall(function()
        if type(discordBanner.SetImage) == "function" then
            discordBanner:SetImage(img)
        elseif type(discordBanner.Set) == "function" then
            discordBanner:Set({ Image = img })
        elseif discordBanner.Image ~= nil then
            discordBanner.Image = img
        end
    end)
end

infoTab:Button({
    Title = "loc:button.discord",
    Icon = "message-circle",
    Callback = function()
        pcall(function() setclipboard("https://discord.gg/Fn74MpzFUn") end)
        pcall(function()
            if notify then
                notify({ MessageKey = "notification.discord_copied", Type = "done" })
            elseif VortexNotify and VortexNotify.Show then
                VortexNotify.Show("Discord", "Invite copiado al portapapeles", 2.5)
            end
        end)
    end
})

infoTab:Button({
    Title = "loc:button.website",
    Icon = "globe",
    Callback = function()
        pcall(function() setclipboard("https://flexushub-scripts.netlify.app/") end)
        pcall(function()
            if notify then
                notify({ MessageKey = "notification.website_copied", Type = "done" })
            elseif VortexNotify and VortexNotify.Show then
                VortexNotify.Show("Website", "Link copiado al portapapeles", 2.5)
            end
        end)
    end
})

infoTab:Divider({Title = "loc:section.appearance"})
local languageDropdown
local function refreshLanguageDropdown()
    if not languageDropdown or type(languageDropdown.Refresh) ~= "function" then
        return
    end

    languageOptions = makeOptions(languageOptionDefinitions)
    local selected = optionByValue(languageOptions, activeLanguage)
    languageDropdown:Refresh(languageOptions, true)
    if selected then
        languageDropdown:Select(selected, true)
    end
end

languageDropdown = infoTab:Dropdown({
    Title = "loc:control.language",
    Flag = "InterfaceLanguage",
    Values = languageOptions,
    Value = optionByValue(languageOptions, activeLanguage),
    Callback = function(languageCode)
        local normalizedLanguage = normalizeLanguage(optionValue(languageCode, languageOptions))
        if normalizedLanguage == activeLanguage then
            refreshLanguageDropdown()
            return
        end

        activeLanguage = normalizedLanguage
        WindUI:SetLanguage(activeLanguage)
        refreshLanguageDropdown()
    end
})
infoTab:Dropdown({
    Title = "loc:control.theme",
    Flag = "InterfaceTheme",
    Values = themeOptions,
    Value = themeOptions[1],
    Callback = function(themeName)
        themeName = optionValue(themeName, themeOptions)
        local background = themeBackgrounds[themeName]
        if background then
            WindUI:SetTheme(themeName)
            Window:SetBackgroundImage(background)
            Window:SetBackgroundImageTransparency(0.22)
            pcall(function() updateDiscordBannerImage(themeName) end)
            -- OpenButton stroke colors por theme
            pcall(function()
                if themeName == "Golden" then
                    -- dorado
                elseif themeName == "Neon Blue" then
                    -- azul
                end
            end)
        end
    end
})
infoTab:Divider({Title = "loc:section.report"})
local reportText = ""
local lastReportTime = 0
infoTab:Input({
    Title = "loc:control.message",
    Flag = "ReportText",
    Value = "",
    Placeholder = t("placeholder.report"),
    Callback = function(t)
        reportText = t
    end
})
infoTab:Button({
    Title = "loc:button.send_report",
    Callback = function()
        local currentTime = os.time()
        if currentTime - lastReportTime < 60 then
            notify({ MessageKey = "notification.wait", Args = {60 - (currentTime - lastReportTime)}, Type = "warning" })
            return
        end
        if reportText == "" or reportText:match("^%s*$") then
            notify({ MessageKey = "notification.enter_message", Type = "warning" })
            return
        end
-- FlexusHub Reports -> Web API (+ Discord fallback)
local REPORT_API_URL = "https://vortex-x-sage.vercel.app/api/report"
local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1555645993247051906/5spy-DPMDAL5qhbS2mk5S-wesGubALPm5JhtiNO9CR34A70x2VKTk2Du2jmTPx37cGi1"
local reportHttpService = game:GetService("HttpService")
local reportPlayer = game:GetService("Players").LocalPlayer
local reportGameName = tostring(game.PlaceId)
do
    local productInfoSuccess, productInfo = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    end)
    if productInfoSuccess and productInfo and productInfo.Name then
        reportGameName = productInfo.Name
    end
end

local function isReportResponseSuccessful(success, response)
    if not success then
        return false
    end
    if type(response) ~= "table" then
        return true
    end
    local statusCode = response.StatusCode or response.Status or response.statusCode or response.status
    if statusCode == nil then
        return true
    end
    statusCode = tonumber(statusCode) or 0
    return statusCode >= 200 and statusCode < 300
end

local function httpPostJson(url, body)
    local headers = {
        ["Content-Type"] = "application/json",
        ["X-Flexus-Client"] = "executor",
    }
    local function tryReq(fn)
        if type(fn) ~= "function" then return false end
        local ok, res = pcall(function()
            return fn({ Url = url, Method = "POST", Headers = headers, Body = body })
        end)
        return isReportResponseSuccessful(ok, res)
    end
    if tryReq(request) or tryReq(syn and syn.request) or tryReq(http_request) or tryReq(fluxus and fluxus.request) then
        return true
    end
    local ok, res = pcall(function()
        return reportHttpService:RequestAsync({
            Url = url,
            Method = "POST",
            Headers = headers,
            Body = body,
        })
    end)
    return isReportResponseSuccessful(ok, res)
end

local function sendReport()
    local executorName = "Unknown"
    pcall(function()
        if getexecutorname then executorName = tostring(getexecutorname()) end
    end)

    local userLine = string.format("%s (@%s) | ID: %s", reportPlayer.DisplayName or "?", reportPlayer.Name or "?", tostring(reportPlayer.UserId or "?"))
    local msg = tostring(reportText or ""):sub(1, 1800)

    local plainPayload = reportHttpService:JSONEncode({
        message = msg,
        game = reportGameName,
        placeId = tostring(game.PlaceId),
        jobId = tostring(game.JobId),
        username = reportPlayer.Name,
        displayName = reportPlayer.DisplayName,
        userId = tostring(reportPlayer.UserId),
        executor = executorName,
        script = "FlexusHub [Duels]",
    })

    -- 1) Web API (Vercel) -> reenvia a Discord
    local okWeb = httpPostJson(REPORT_API_URL, plainPayload)

    -- 2) Fallback directo a Discord si la web falla
    local okDiscord = false
    if not okWeb then
        local embed = {
            title = "FlexusHub — Nuevo reporte",
            description = msg,
            color = 16766720,
            fields = {
                { name = "Jugador", value = userLine, inline = false },
                { name = "Juego", value = tostring(reportGameName), inline = true },
                { name = "PlaceId", value = tostring(game.PlaceId), inline = true },
                { name = "JobId", value = tostring(game.JobId):sub(1, 40), inline = false },
                { name = "Executor", value = executorName, inline = true },
                { name = "Script", value = "FlexusHub [Duels]", inline = true },
            },
            footer = { text = "FlexusHub Reports · Fallback" },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        }
        local discordPayload = reportHttpService:JSONEncode({
            username = "FlexusHub Reports",
            embeds = { embed },
        })
        okDiscord = httpPostJson(DISCORD_WEBHOOK, discordPayload)
    end

    if okWeb or okDiscord then
        notify({ MessageKey = "notification.report_sent", Type = "done" })
        lastReportTime = currentTime
        pcall(function()
            if VortexNotify and VortexNotify.Show then
                VortexNotify.Show("Reporte", okWeb and "Enviado (Web → Discord)" or "Enviado (Discord)", 2.5)
            end
        end)
    else
        notify({ MessageKey = "notification.report_failed", Type = "error" })
    end
end

task.spawn(sendReport)
    end
})

end)()

;(function()
local keybindTab = Window:Tab({Title = "loc:tab.keybinds", Icon = "keyboard", ShowTabTitle = true, Border = true})
keybindTab:Divider({Title = "loc:section.interface"})
local uiToggleKey = Enum.KeyCode.RightShift
local toggleKeybindObj = keybindTab:Keybind({
    Title = "loc:control.toggle_ui",
    Flag = "ToggleUIKB",
    Value = "RightShift",
    Callback = function(v)
        if v == "None" then
            uiToggleKey = nil
        else
            local key = typeof(v) == "EnumItem" and v or Enum.KeyCode[v]
            if key then uiToggleKey = key end
        end
    end
})

keybindTab:Divider({Title = "Combate & ESP"})
local function parseKB(v)
    if v == nil or v == "None" or v == "" then return nil end
    if typeof(v) == "EnumItem" then return v end
    local ok, key = pcall(function() return Enum.KeyCode[tostring(v)] end)
    if ok then return key end
    return nil
end

local espKey, aimbotKey, silentKey, autoKey, macroKey, triggerKey, hitboxKey = nil, nil, nil, nil, nil, nil, nil
-- Kill All keybind bloqueado (no variable activa)

keybindTab:Keybind({
    Title = "ESP",
    Flag = "EspKB",
    Value = "None",
    Callback = function(v) espKey = parseKB(v) end
})
keybindTab:Keybind({
    Title = "Aimbot (Camlock)",
    Flag = "AimbotKB",
    Value = "None",
    Callback = function(v) aimbotKey = parseKB(v) end
})
keybindTab:Keybind({
    Title = "Silent Aim",
    Flag = "SilentKB",
    Value = "None",
    Callback = function(v) silentKey = parseKB(v) end
})
keybindTab:Keybind({
    Title = "Auto Shoot",
    Flag = "AutoShootKB",
    Value = "None",
    Callback = function(v) autoKey = parseKB(v) end
})
keybindTab:Keybind({
    Title = "Macro",
    Flag = "MacroKB",
    Value = "None",
    Callback = function(v) macroKey = parseKB(v) end
})
keybindTab:Keybind({
    Title = "TriggerBot",
    Flag = "TriggerKB",
    Value = "None",
    Callback = function(v) triggerKey = parseKB(v) end
})
keybindTab:Keybind({
    Title = "Hitbox",
    Flag = "HitboxKB",
    Value = "None",
    Callback = function(v) hitboxKey = parseKB(v) end
})

local killAllKB = keybindTab:Keybind({
    Title = "Kill All",
    Desc = "Atajo para activar/desactivar Kill All.",
    Flag = "KillAllKB",
    Value = "K",
    Callback = function(v)
        if type(v) == "string" and v ~= "" and v ~= "None" then
            KillAllKeybind = v
        end
    end
})
-- Kill All keybind activo

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if uiToggleKey and input.KeyCode == uiToggleKey then
        if Window.Closed then Window:Open() else Window:Close(true) end
    end
    local function bumpBubble(key, state)
        pcall(function() if _G.VXS_UpdateBubble then _G.VXS_UpdateBubble(key, state) end end)
        pcall(function() if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end end)
    end
    if espKey and input.KeyCode == espKey then
        espEnabled = not espEnabled
        bumpBubble("esp", espEnabled)
    end
    if aimbotKey and input.KeyCode == aimbotKey then
        camlockEnabled = not camlockEnabled
        bumpBubble("aimbot", camlockEnabled)
    end
    if silentKey and input.KeyCode == silentKey then
        silentAimManualEnabled = not silentAimManualEnabled
        bumpBubble("silent", silentAimManualEnabled)
    end
    if autoKey and input.KeyCode == autoKey then
        autoShootEnabled = not autoShootEnabled
        bumpBubble("auto", autoShootEnabled)
    end
    if macroKey and input.KeyCode == macroKey then
        macroActive = not macroActive
        bumpBubble("macro", macroActive)
    end
    if triggerKey and input.KeyCode == triggerKey then
        dmvsAutoMacroState.Enabled = not dmvsAutoMacroState.Enabled
        dmvsAutoMacroState.TeamCheck = true
        dmvsAutoMacroState.WallCheck = true
        bumpBubble("trigger", dmvsAutoMacroState.Enabled)
    end
    if hitboxKey and input.KeyCode == hitboxKey then
        hitboxEnabled = not hitboxEnabled
        if not hitboxEnabled then pcall(clearAllHitboxes) end
        bumpBubble("hitbox", hitboxEnabled)
    end
    -- Kill All: sin keybind funcional
end)

end)()

;(function()
local combateTab = Window:Tab({Title = "Combate", Icon = "swords", ShowTabTitle = true, Border = true})

-- ---------- Camlock / Aimbot ----------
combateTab:Divider({Title = "Aimbot (Camlock)"})
combateTab:Toggle({
    Title = "Enable Aimbot",
    Desc = "Camlock al enemigo dentro del FOV.",
    Flag = "CamlockEnable",
    Value = false,
    Callback = function(s) camlockEnabled = s; pcall(function() if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end end) end
})
combateTab:Toggle({
    Title = "Only Gun",
    Desc = "Solo apunta si tienes pistola equipada.",
    Flag = "CamlockOnlyGun",
    Value = false,
    Callback = function(s) camlockOnlyGun = s end
})
combateTab:Toggle({
    Title = "Show FOV",
    Flag = "CamlockFOVVisible",
    Value = false,
    Callback = function(s) camlockFOVVisible = s end
})
combateTab:Dropdown({
    Title = "Target Part",
    Flag = "CamlockPart",
    Values = targetPartOptions,
    Value = targetPartOptions[1],
    Callback = function(v) camlockTargetPart = optionValue(v, targetPartOptions) end
})
combateTab:Dropdown({
    Title = "Aim Mode",
    Flag = "CamlockMode",
    Values = aimModeOptions,
    Value = aimModeOptions[3],
    Callback = function(v) camlockMode = optionValue(v, aimModeOptions) end
})
combateTab:Slider({
    Title = "Smoothness",
    Flag = "CamlockSmooth",
    Value = {Min = 0, Max = 1, Default = 1},
    Step = 0.01,
    Callback = function(v) camlockSmoothness = math.clamp(tonumber(v) or 1, 0, 1) end
})
combateTab:Slider({
    Title = "FOV Radius",
    Flag = "CamlockFOVRadius",
    Value = {Min = 10, Max = 800, Default = 120},
    Step = 1,
    Callback = function(v) camlockFOVRadius = v end
})
combateTab:Colorpicker({
    Title = "FOV Color",
    Flag = "CamlockFOVColor",
    Default = Color3.fromRGB(255, 220, 90),
    Callback = function(c) camlockFOVColor = c end
})

-- ---------- Silent Aim ----------
combateTab:Divider({Title = "Silent Aim"})
_G.VXS_CombatToggles = _G.VXS_CombatToggles or {}
_G.VXS_CombatToggles.silent = combateTab:Toggle({
    Title = "Silent Aim",
    Desc = "Redirige las balas al enemigo (solo enemigos).",
    Flag = "VXS_SilentAim",
    Value = false,
    Callback = function(v)
        silentAimManualEnabled = v
        if not v and not autoShootEnabled then
            pcall(function() if getgenv then getgenv()._VXS_AP = nil end end)
            SilentCurrentTarget = nil
        end
        pcall(function()
            if _G.VXS_UpdateBubble then _G.VXS_UpdateBubble("silent", v) end
            if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end
        end)
    end
})
combateTab:Dropdown({
    Title = "Silent Target",
    Flag = "VXS_SilentPart",
    Values = {"Head", "Torso", "Full Body"},
    Value = "Head",
    Callback = function(v)
        if type(v) == "table" then v = v.Value or v.Title or "Head" end
        if v == "Full Body" then silentAimTargetPart = "Full" else silentAimTargetPart = v end
    end
})
-- Silent Mode fijo: Nearest (no se puede cambiar)
silentAimMode = "Nearest"
combateTab:Toggle({
    Title = "Show Silent FOV",
    Flag = "VXS_SilentShowFOV",
    Value = false,
    Callback = function(v) silentAimFOVVisible = v end
})
combateTab:Slider({
    Title = "Silent FOV",
    Flag = "VXS_SilentFOV",
    Value = {Min = 10, Max = 800, Default = 120},
    Step = 1,
    Callback = function(v) silentAimFOVRadius = v end
})

-- ---------- Auto Shoot ----------
combateTab:Divider({Title = "Auto Shoot"})
_G.VXS_CombatToggles = _G.VXS_CombatToggles or {}
_G.VXS_CombatToggles.auto = combateTab:Toggle({
    Title = "Auto Shoot",
    Desc = "Dispara si ya tienes el arma equipada (no equipa sola).",
    Flag = "VXS_AutoShoot",
    Value = false,
    Callback = function(v)
        autoShootEnabled = v
        if not v and not silentAimManualEnabled then
            pcall(function() if getgenv then getgenv()._VXS_AP = nil end end)
            AutoCurrentTarget = nil
        end
        pcall(function()
            if _G.VXS_UpdateBubble then _G.VXS_UpdateBubble("auto", v) end
            if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end
        end)
    end
})
combateTab:Toggle({
    Title = "Auto Shoot Agresivo",
    Desc = "Apunta a cualquier parte del cuerpo visible.",
    Flag = "VXS_AutoShootAgr",
    Value = false,
    Callback = function(v)
        autoShootAgresivoEnabled = v
        if v then autoShootEnabled = true end
    end
})
combateTab:Toggle({
    Title = "Silent Aim (FOV)",
    Desc = "Silent solo dentro del circulo FOV.",
    Flag = "VXS_SilentFOVMode",
    Value = false,
    Callback = function(v)
        silentAimFovEnabled = v
        if v then silentAimManualEnabled = true end
    end
})

combateTab:Toggle({
    Title = "Auto Shoot Knife",
    Desc = "Tambien con cuchillo equipado.",
    Flag = "VXS_AutoKnife",
    Value = false,
    Callback = function(v) autoShootCuchilloEnabled = v end
})
combateTab:Dropdown({
    Title = "Auto Target",
    Flag = "VXS_AutoPart",
    Values = {"Head", "Torso", "Full Body"},
    Value = "Head",
    Callback = function(v)
        if type(v) == "table" then v = v.Value or v.Title or "Head" end
        if v == "Full Body" then autoShootTargetPart = "Full" else autoShootTargetPart = v end
    end
})

-- ---------- Hitbox ----------
combateTab:Divider({Title = "Hitbox"})
_G.VXS_CombatToggles = _G.VXS_CombatToggles or {}
_G.VXS_CombatToggles.hitbox = combateTab:Toggle({
    Title = "Enable Hitbox",
    Desc = "Hitbox expandida solo en enemigos.",
    Flag = "HitboxEnable",
    Value = false,
    Callback = function(s)
        hitboxEnabled = s
        if not s then clearAllHitboxes() end
        pcall(function()
            if _G.VXS_UpdateBubble then _G.VXS_UpdateBubble("hitbox", s) end
            if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end
        end)
    end
})
combateTab:Slider({
    Title = "Hitbox Size",
    Flag = "HitboxSize",
    Value = {Min = 3, Max = 15, Default = 10},
    Step = 1,
    Callback = function(v)
        hitboxSizeValue = v
        CustomHitboxSize = Vector3.new(v, v, v)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then
                local hb = plr.Character:FindFirstChild("GhostHitbox")
                if hb then hb.Size = CustomHitboxSize end
            end
        end
    end
})
combateTab:Slider({
    Title = "Hitbox Transparency",
    Flag = "HitboxTransparency",
    Value = {Min = 0, Max = 1, Default = 0.7},
    Step = 0.05,
    Callback = function(v)
        hitboxTransparency = v
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then
                local hb = plr.Character:FindFirstChild("GhostHitbox")
                if hb then hb.Transparency = v end
            end
        end
    end
})

-- ---------- Macro (tap to shoot) ----------
combateTab:Divider({Title = "Macro"})
_G.VXS_CombatToggles = _G.VXS_CombatToggles or {}
_G.VXS_CombatToggles.macro = combateTab:Toggle({
    Title = "Enable Macro",
    Desc = "Al tocar/clic (fuera de zona muerta) equipa y dispara.",
    Flag = "MacroEnable",
    Value = false,
    Callback = function(s)
        macroActive = s
        pcall(function()
            if _G.VXS_UpdateBubble then _G.VXS_UpdateBubble("macro", s) end
            if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end
        end)
    end
})
-- delays fijos (no editables en UI)
macroEquipDelay = 0.04
macroShootDelay = 0.10

-- ---------- TriggerBot (ex Macro 360) ----------
combateTab:Divider({Title = "TriggerBot"})
_G.VXS_CombatToggles = _G.VXS_CombatToggles or {}
_G.VXS_CombatToggles.trigger = combateTab:Toggle({
    Title = "TriggerBot",
    Desc = "Detecta enemigo, equipa arma y dispara solo. Opciones fijas internas.",
    Flag = "VXS_TriggerBot",
    Value = false,
    Callback = function(value)
        dmvsAutoMacroState.Enabled = value
        -- defaults fijos (no se pueden cambiar en UI)
        dmvsAutoMacroState.TeamCheck = true
        dmvsAutoMacroState.WallCheck = true
        dmvsAutoMacroState.TargetPart = "Head"
        dmvsAutoMacroState.EquipDelay = 0.04
        dmvsAutoMacroState.ShootDelay = 0.10
        dmvsAutoMacroState.ScanDelay = 0.03
        if not value then
            dmvsAutoMacroState.CurrentTarget = nil
            if dmvsAutoMacroState.ManagedGun then
                local character = player.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                pcall(function()
                    dmvsAutoMacroCleanupGun(dmvsAutoMacroState.ManagedGun, character, humanoid)
                end)
            end
        end
        pcall(function()
            if _G.VXS_UpdateBubble then _G.VXS_UpdateBubble("trigger", value) end
            if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end
        end)
    end
})
combateTab:Slider({
    Title = "TriggerBot Range",
    Desc = "Distancia maxima de deteccion.",
    Flag = "VXS_TriggerRange",
    Value = {Min = 25, Max = 500, Default = 250},
    Step = 5,
    Callback = function(value)
        dmvsAutoMacroState.Range = value
    end
})

-- ---------- Dead Zone ----------

combateTab:Divider({Title = "Kill All"})
local KillAllEnabled = false
local KillAllKeybind = "K"
UIElements = UIElements or {}

local function applyKillAll(state)
    KillAllEnabled = state and true or false
    if dmvsKillAllState then dmvsKillAllState.Enabled = KillAllEnabled end
    pcall(function()
        if KillAllEnabled then
            if KillAllInstance and KillAllInstance.Start then KillAllInstance:Start() end
        else
            if KillAllInstance and KillAllInstance.Stop then KillAllInstance:Stop() end
        end
    end)
    pcall(function()
        if _G.VXS_UpdateBubble then _G.VXS_UpdateBubble("killall", KillAllEnabled) end
    end)
    pcall(function()
        if notify then notify({Title = "Kill All", Content = KillAllEnabled and "ON" or "OFF"}) end
    end)
end

local killAllToggle = combateTab:Toggle({
    Title = "Kill All",
    Desc = "Fase beta: se acerca y ataca enemigos con cuchillo.",
    Flag = "VXS_KillAll",
    Value = false,
    Callback = function(value)
        applyKillAll(value)
    end
})
UIElements.TogKillAll = killAllToggle
_G.VXS_CombatToggles = _G.VXS_CombatToggles or {}
_G.VXS_CombatToggles.killall = killAllToggle

combateTab:Keybind({
    Title = "Tecla Kill All",
    Desc = "Atajo para activar/desactivar Kill All.",
    Flag = "VXS_KillAllKB",
    Value = KillAllKeybind,
    Callback = function(k)
        if type(k) == "string" and k ~= "" and k ~= "None" then
            KillAllKeybind = k
        end
    end
})

combateTab:Slider({
    Title = "Jitter",
    Desc = "Vibracion lateral al acercarse (0 = apagado).",
    Flag = "VXS_KillAllJitterAmp",
    Step = 0.05,
    Value = { Min = 0.0, Max = 3.0, Default = 0.8 },
    Callback = function(v)
        KILLALL_JITTER_AMPLITUDE = v
        KillAllJitterEnabled = (v or 0) > 0.01
    end
})

combateTab:Slider({
    Title = "Radio de activacion",
    Desc = "Distancia a la que se activa el ataque.",
    Flag = "VXS_KillAllRadius",
    Step = 0.5,
    Value = { Min = 2.75, Max = 9.0, Default = 6.0 },
    Callback = function(v)
        KILLALL_TRIGGER_RADIUS = v
        KillAllTriggerRadius = v
    end
})

-- Keybind listener
pcall(function()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        local keyName = KillAllKeybind
        if not keyName or keyName == "" or keyName == "None" then return end
        local ok, code = pcall(function() return Enum.KeyCode[keyName] end)
        if ok and code and input.KeyCode == code then
            local newState = not KillAllEnabled
            applyKillAll(newState)
            pcall(function()
                if killAllToggle and killAllToggle.Set then killAllToggle:Set(newState) end
            end)
        end
    end)
end)

-- ---------- Bubbles ----------

-- refs de toggles para sync con bubbles (se rellenan abajo si aplica)
if not _G.VXS_CombatToggles then _G.VXS_CombatToggles = {} end

end)()


-- ===== BUBBLES TAB =====
;(function()
local bubblesTab = Window:Tab({Title = "Bubbles", Icon = "circle", ShowTabTitle = true, Border = true})

local bubbleDragMode = false
local bubbleVisible = {
    silent = false,
    auto = false,
    macro = false,
    trigger = false,
    hitbox = false,
}

bubblesTab:Divider({Title = "Control"})
bubblesTab:Toggle({
    Title = "Modo Arrastrar",
    Desc = "Solo con esto ON puedes mover las bubbles.",
    Flag = "VXS_BubbleDrag",
    Value = false,
    Callback = function(v)
        bubbleDragMode = v
        _G.VXS_BubbleDragState = v
        pcall(function() if _G.VXS_BubbleDragMode then _G.VXS_BubbleDragMode(v) end end)
        pcall(function() if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end end)
    end
})

bubblesTab:Divider({Title = "Mostrar bubbles"})
bubblesTab:Toggle({
    Title = "Bubble Silent Aim",
    Flag = "VXS_BubbleShowSilent",
    Value = false,
    Callback = function(v)
        bubbleVisible.silent = v
        if _G.VXS_BubbleVisibility then _G.VXS_BubbleVisibility.silent = v end
        pcall(function() if _G.VXS_BubbleShow then _G.VXS_BubbleShow("silent", v) end end)
        pcall(function() if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end end)
    end
})
bubblesTab:Toggle({
    Title = "Bubble Auto Shoot",
    Flag = "VXS_BubbleShowAuto",
    Value = false,
    Callback = function(v)
        bubbleVisible.auto = v
        if _G.VXS_BubbleVisibility then _G.VXS_BubbleVisibility.auto = v end
        pcall(function() if _G.VXS_BubbleShow then _G.VXS_BubbleShow("auto", v) end end)
        pcall(function() if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end end)
    end
})
bubblesTab:Toggle({
    Title = "Bubble Macro",
    Flag = "VXS_BubbleShowMacro",
    Value = false,
    Callback = function(v)
        bubbleVisible.macro = v
        if _G.VXS_BubbleVisibility then _G.VXS_BubbleVisibility.macro = v end
        pcall(function() if _G.VXS_BubbleShow then _G.VXS_BubbleShow("macro", v) end end)
        pcall(function() if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end end)
    end
})
bubblesTab:Toggle({
    Title = "Bubble TriggerBot",
    Flag = "VXS_BubbleShowTrigger",
    Value = false,
    Callback = function(v)
        bubbleVisible.trigger = v
        if _G.VXS_BubbleVisibility then _G.VXS_BubbleVisibility.trigger = v end
        pcall(function() if _G.VXS_BubbleShow then _G.VXS_BubbleShow("trigger", v) end end)
        pcall(function() if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end end)
    end
})
bubblesTab:Toggle({
    Title = "Bubble Hitbox",
    Flag = "VXS_BubbleShowHitbox",
    Value = false,
    Callback = function(v)
        bubbleVisible.hitbox = v
        if _G.VXS_BubbleVisibility then _G.VXS_BubbleVisibility.hitbox = v end
        pcall(function() if _G.VXS_BubbleShow then _G.VXS_BubbleShow("hitbox", v) end end)
        pcall(function() if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end end)
    end
})
local kaBubbleToggle = bubblesTab:Toggle({
    Title = "Bubble Kill All",
    Desc = "Mostrar u ocultar la bubble de Kill All.",
    Flag = "VXS_BubbleShowKillAll",
    Value = true,
    Callback = function(v)
        pcall(function()
            if _G.VXS_BubbleShow then _G.VXS_BubbleShow("killall", v and true or false) end
        end)
    end
})


-- Crear bubbles gris/blanco
task.spawn(function()
    local CoreGui = game:GetService("CoreGui")
    local host
    pcall(function() if gethui then host = gethui() end end)
    if not host then host = player:FindFirstChild("PlayerGui") or CoreGui end

    local gui = Instance.new("ScreenGui")
    gui.Name = "VXS_Bbl_" .. tostring(math.random(10000,99999))
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 125
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() gui.Parent = host end)
    _G.VXS_BubbleGui = gui
    _G.VXS_Bubbles = bubbles
    if not gui.Parent then gui.Parent = player:WaitForChild("PlayerGui") end

    local defs = {
        {key = "silent",  label = "SA", tip = "Silent Aim", locked = false},
        {key = "auto",    label = "AS", tip = "Auto Shoot", locked = false},
        {key = "macro",   label = "MC", tip = "Macro", locked = false},
        {key = "trigger", label = "TB", tip = "TriggerBot", locked = false},
        {key = "hitbox",  label = "HB", tip = "Hitbox", locked = false},
        {key = "killall", label = "KA", tip = "Kill All", locked = false},
    }

    local function getState(key)
        if key == "silent" then return silentAimManualEnabled
        elseif key == "auto" then return autoShootEnabled
        elseif key == "macro" then return macroActive
        elseif key == "trigger" then return dmvsAutoMacroState and dmvsAutoMacroState.Enabled
        elseif key == "hitbox" then return hitboxEnabled
        elseif key == "killall" then return (dmvsKillAllState and dmvsKillAllState.Enabled) or (KillAllEnabled == true)
        end
        return false
    end

    -- Aplica logica + intenta reflejar toggle del menu si WindUI expone Set
    local function setState(key, value)
        if key == "killall" then
            local on = value and true or false
            KillAllEnabled = on
            if dmvsKillAllState then dmvsKillAllState.Enabled = on end
            pcall(function()
                if on then
                    if KillAllInstance and KillAllInstance.Start then KillAllInstance:Start() end
                else
                    if KillAllInstance and KillAllInstance.Stop then KillAllInstance:Stop() end
                end
            end)
            pcall(function()
                local tog = (_G.VXS_CombatToggles and _G.VXS_CombatToggles.killall) or (UIElements and UIElements.TogKillAll)
                if tog and tog.Set then tog:Set(on) end
            end)
            pcall(function() if notify then notify({Title = "Kill All", Content = on and "ON" or "OFF"}) end end)
            return
        end
        if key == "silent" then
            silentAimManualEnabled = value
            if not value and not autoShootEnabled then
                pcall(function() if getgenv then getgenv()._VXS_AP = nil end end)
                SilentCurrentTarget = nil
            end
        elseif key == "auto" then
            autoShootEnabled = value
            if not value and not silentAimManualEnabled then
                pcall(function() if getgenv then getgenv()._VXS_AP = nil end end)
                AutoCurrentTarget = nil
            end
        elseif key == "macro" then
            macroActive = value
        elseif key == "trigger" then
            dmvsAutoMacroState.Enabled = value
            dmvsAutoMacroState.TeamCheck = true
            dmvsAutoMacroState.WallCheck = true
            dmvsAutoMacroState.TargetPart = "Head"
            if not value then
                dmvsAutoMacroState.CurrentTarget = nil
                if dmvsAutoMacroState.ManagedGun then
                    local character = player.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    pcall(function() dmvsAutoMacroCleanupGun(dmvsAutoMacroState.ManagedGun, character, humanoid) end)
                end
            end
        elseif key == "hitbox" then
            hitboxEnabled = value
            if not value then pcall(clearAllHitboxes) end
        end
        -- Sync visual de toggles del menu (bubble <-> toggle)
        pcall(function()
            local flagMap = {
                silent = "VXS_SilentAim",
                auto = "VXS_AutoShoot",
                macro = "MacroEnable",
                trigger = "VXS_TriggerBot",
                hitbox = "HitboxEnable",
            }
            local flag = flagMap[key]
            local refs = _G.VXS_CombatToggles
            if refs and refs[key] then
                local el = refs[key]
                if type(el) == "table" then
                    pcall(function()
                        if el.Set then el:Set(value)
                        elseif el.SetValue then el:SetValue(value)
                        elseif el.SetState then el:SetState(value)
                        elseif el.Update then el:Update(value)
                        elseif el.Callback and el.Value ~= nil then
                            el.Value = value
                        end
                    end)
                end
            end
            if flag and WindUI then
                pcall(function()
                    if WindUI.SetFlag then WindUI:SetFlag(flag, value) end
                    if type(WindUI.Flags) == "table" then WindUI.Flags[flag] = value end
                end)
            end
            if flag and Window then
                pcall(function()
                    if Window.SetFlag then Window:SetFlag(flag, value) end
                    if Window.Flags and type(Window.Flags) == "table" then Window.Flags[flag] = value end
                end)
            end
            -- ConfigManager de WindUI
            pcall(function()
                if Window and Window.ConfigManager and Window.ConfigManager.Set then
                    Window.ConfigManager:Set(flag, value)
                end
            end)
        end)
        pcall(function()
            if notify then notify({Title = key, Content = value and "ON" or "OFF"}) end
        end)
        pcall(function() if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end end)
    end

    local bubbles = {}
    local white = Color3.fromRGB(245, 245, 245)
    local gray = Color3.fromRGB(55, 55, 60)
    local grayOn = Color3.fromRGB(210, 210, 215)
    local textOff = Color3.fromRGB(200, 200, 205)
    local textOn = Color3.fromRGB(25, 25, 28)
    local size = 42
    local startY = 0.36
    local gap = 48

    local function styleBtn(btn, on)
        btn.BackgroundColor3 = on and grayOn or gray
        btn.TextColor3 = on and textOn or textOff
        local st = btn:FindFirstChildOfClass("UIStroke")
        if st then st.Color = on and white or Color3.fromRGB(140, 140, 145) end
    end

    for i, def in ipairs(defs) do
        local btn = Instance.new("TextButton")
        btn.Name = "B_" .. def.key
        btn.Size = UDim2.fromOffset(size, size)
        btn.AnchorPoint = Vector2.new(1, 0)
        btn.Position = UDim2.new(1, -14, startY, (i - 1) * gap)
        btn.BackgroundColor3 = gray
        btn.BackgroundTransparency = 0.12
        btn.Text = def.label
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.TextColor3 = textOff
        btn.AutoButtonColor = false
        btn.Visible = false
        btn.ZIndex = 60
        btn.Parent = gui
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)
        local st = Instance.new("UIStroke", btn)
        st.Thickness = 1.2
        st.Color = Color3.fromRGB(140, 140, 145)
        st.Transparency = 0.15

        local dragging, moved, dragStart, startPos = false, false, nil, nil
        btn.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            if not bubbleDragMode then return end
            dragging = true
            moved = false
            dragStart = input.Position
            startPos = btn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end)
        UserInputService.InputChanged:Connect(function(input)
            if not dragging or not bubbleDragMode then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local d = input.Position - dragStart
                if d.Magnitude > 4 then moved = true end
                btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)

        -- Candado visual si locked
        if def.locked then
            btn.Text = "KA"
            btn.BackgroundTransparency = 0.35
            local lockLbl = Instance.new("TextLabel")
            lockLbl.Name = "Lock"
            lockLbl.Size = UDim2.fromScale(1, 1)
            lockLbl.BackgroundTransparency = 1
            lockLbl.Text = "🔒"
            lockLbl.TextSize = 14
            lockLbl.Font = Enum.Font.GothamBold
            lockLbl.TextColor3 = Color3.fromRGB(180, 180, 185)
            lockLbl.ZIndex = 70
            lockLbl.Parent = btn
            btn.TextTransparency = 0.5
        end

        btn.MouseButton1Click:Connect(function()
            if bubbleDragMode and moved then
                pcall(function() if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end end)
                return
            end
            if def.locked then
                pcall(function() if notify then notify({Title = def.tip, Content = "Bloqueado (Proximamente)"}) end end)
                styleBtn(btn, false)
                return
            end
            local newState = not getState(def.key)
            setState(def.key, newState)
            styleBtn(btn, newState)
        end)

        bubbles[def.key] = btn
        styleBtn(btn, getState(def.key))
        -- restaurar posicion guardada
        pcall(function()
            local saved = _G.VXS_SavedBubblePos and _G.VXS_SavedBubblePos[def.key]
            if saved then
                btn.Position = UDim2.new(saved.XS or 1, saved.XO or -54, saved.YS or 0.36, saved.YO or 0)
                if saved.Visible ~= nil then btn.Visible = saved.Visible and true or false end
            end
        end)
    end

    _G.VXS_UpdateBubble = function(key, state)
        local btn = bubbles[key]
        if btn then styleBtn(btn, state and true or false) end
    end
    _G.VXS_BubbleShow = function(key, vis)
        local btn = bubbles[key]
        if btn then
            btn.Visible = vis and true or false
            if vis then styleBtn(btn, getState(key)) end
        end
    end
    _G.VXS_BubbleDragMode = function(v)
        bubbleDragMode = v and true or false
    end
    _G.VXS_SetCombatFromUI = function(key, value)
        local btn = bubbles[key]
        if btn then styleBtn(btn, value and true or false) end
    end
    -- re-aplicar estados y visual de toggles (config puede haber cargado antes)
    task.defer(function()
        task.wait(0.2)
        pcall(function()
            if vxsSyncAllToggleVisuals then vxsSyncAllToggleVisuals() end
        end)
        styleBtn(bubbles.silent, getState("silent"))
        styleBtn(bubbles.auto, getState("auto"))
        styleBtn(bubbles.macro, getState("macro"))
        styleBtn(bubbles.trigger, getState("trigger"))
        styleBtn(bubbles.hitbox, getState("hitbox"))
    end)
end)

end)()

-- ===== FARM TAB (Onyx) =====
;(function()
local farmTab = Window:Tab({Title = "Farm", Icon = "coins", ShowTabTitle = true, Border = true})


farmTab:Divider({Title = "Pads / Plataformas"})
local autoTPMainToggle, autoTPAltToggle
autoTPMainToggle = farmTab:Toggle({
    Title = "Auto Teleport (Main)",
    Desc = "Te lleva al pad Main. Se desactiva si activas Alt.",
    Flag = "VXS_AutoTP_Main",
    Value = false,
    Callback = function(value)
        if not AutoTeleportMainAltInstance then return end
        if value then
            AutoTeleportMainAltInstance.ActiveRole = "Main"
            pcall(function()
                if autoTPAltToggle and autoTPAltToggle.Set then autoTPAltToggle:Set(false) end
            end)
            AutoTeleportMainAltInstance:Stop()
            AutoTeleportMainAltInstance:Start()
        else
            if AutoTeleportMainAltInstance.ActiveRole == "Main" then
                AutoTeleportMainAltInstance.ActiveRole = nil
                AutoTeleportMainAltInstance:Stop()
            end
        end
    end
})
autoTPAltToggle = farmTab:Toggle({
    Title = "Auto Teleport (Alt)",
    Desc = "Te lleva al pad Alt. Se desactiva si activas Main.",
    Flag = "VXS_AutoTP_Alt",
    Value = false,
    Callback = function(value)
        if not AutoTeleportMainAltInstance then return end
        if value then
            AutoTeleportMainAltInstance.ActiveRole = "Alt"
            pcall(function()
                if autoTPMainToggle and autoTPMainToggle.Set then autoTPMainToggle:Set(false) end
            end)
            AutoTeleportMainAltInstance:Stop()
            AutoTeleportMainAltInstance:Start()
        else
            if AutoTeleportMainAltInstance.ActiveRole == "Alt" then
                AutoTeleportMainAltInstance.ActiveRole = nil
                AutoTeleportMainAltInstance:Stop()
            end
        end
    end
})
farmTab:Dropdown({
    Title = "Tipo de Duelo",
    Flag = "VXS_AutoTP_DuelType",
    Values = { "1v1", "2v2", "3v3", "4v4" },
    Value = "1v1",
    Callback = function(value)
        if not AutoTeleportMainAltInstance then return end
        if PadZoneConfig and PadZoneConfig["Right Platforms"] and PadZoneConfig["Right Platforms"][value] then
            AutoTeleportMainAltInstance.DuelType = value
        else
            AutoTeleportMainAltInstance.DuelType = "1v1"
        end
        pcall(function() AutoTeleportMainAltInstance:Kick() end)
    end
})
farmTab:Dropdown({
    Title = "Fila de Plataformas",
    Flag = "VXS_AutoTP_Row",
    Values = { "Right Platforms", "Left Platforms" },
    Value = "Right Platforms",
    Callback = function(value)
        if not AutoTeleportMainAltInstance then return end
        if PadZoneConfig and PadZoneConfig[value] then
            AutoTeleportMainAltInstance.PlatformRow = value
        else
            AutoTeleportMainAltInstance.PlatformRow = "Right Platforms"
        end
        pcall(function() AutoTeleportMainAltInstance:Kick() end)
    end
})

farmTab:Divider({Title = "Auto Farm"})
local autoFarmCoins = false
local autoEventFarm = false
local RemoteFarm = nil
pcall(function()
    local Networking = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
    if Networking then
        Networking = Networking:FindFirstChild("Networking")
        if Networking then
            RemoteFarm = Networking:FindFirstChild("RE/Events/CollectEventSpawnable")
        end
    end
end)

-- Logica tipo AlexxHub: SpawnablesClient + firetouchinterest (mas fiable)
farmTab:Toggle({
    Title = "Auto Farm Monedas",
    Desc = "Toca todos los spawnables (SpawnablesClient) automaticamente.",
    Flag = "VXS_AutoFarmCoins",
    Value = false,
    Callback = function(state)
        autoFarmCoins = state
        if autoFarmCoins then
            task.spawn(function()
                local spawnables = nil
                pcall(function()
                    spawnables = workspace:FindFirstChild("SpawnablesClient") or workspace:WaitForChild("SpawnablesClient", 10)
                end)
                if not spawnables then
                    pcall(function()
                        if notify then notify({Title = "Auto Farm", Content = "No se encontro SpawnablesClient", Duration = 3}) end
                    end)
                    autoFarmCoins = false
                    return
                end
                while autoFarmCoins and not dmvsDestroyed do
                    local myChar = player.Character
                    local hrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if hrp and firetouchinterest then
                        for _, item in pairs(spawnables:GetChildren()) do
                            if not autoFarmCoins then break end
                            local touchPart = item:FindFirstChild("Touch")
                            if touchPart then
                                pcall(function()
                                    firetouchinterest(hrp, touchPart, 0)
                                    firetouchinterest(hrp, touchPart, 1)
                                end)
                            end
                        end
                    end
                    task.wait(0.45)
                end
            end)
        end
        pcall(function() if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end end)
    end
})


farmTab:Divider({Title = "Cajas (monedas)"})
local selectedBox = "Mythic Box #1"
local availableBoxes = {
    "Mythic Box #1", "Mythic Box #2", "Mythic Box #3", "Mythic Box #4",
    "Gun Box #1", "Gun Box #2",
    "Knife Box #1", "Knife Box #2"
}
farmTab:Dropdown({
    Title = "Selecciona la Caja",
    Flag = "VXS_BoxSelect",
    Values = availableBoxes,
    Value = "Mythic Box #1",
    Callback = function(Value)
        if type(Value) == "table" then Value = Value.Value or Value.Title end
        selectedBox = Value
    end
})
farmTab:Button({
    Title = "Comprar Caja",
    Callback = function()
        local success, result = pcall(function()
            local args = { selectedBox }
            local net = game:GetService("ReplicatedStorage").Packages.Networking
            return net:FindFirstChild("RF/Shop/BuyCase"):InvokeServer(unpack(args))
        end)
        if success then
            pcall(function() if notify then notify({Title = "Caja", Content = "Compra enviada"}) end end)
        else
            pcall(function() if notify then notify({Title = "Caja", Content = "Error al comprar"}) end end)
        end
    end
})

local autoBuyBox = false
farmTab:Toggle({
    Title = "Auto Comprar Caja",
    Desc = "Compra la caja seleccionada en bucle.",
    Flag = "VXS_AutoBuyBox",
    Value = false,
    Callback = function(s)
        autoBuyBox = s
        if s then
            task.spawn(function()
                while autoBuyBox and not dmvsDestroyed do
                    pcall(function()
                        local net = game:GetService("ReplicatedStorage").Packages.Networking
                        net:FindFirstChild("RF/Shop/BuyCase"):InvokeServer(selectedBox)
                    end)
                    task.wait(1.2)
                end
            end)
        end
    end
})
end)()

;(function()
local espTab = Window:Tab({Title = "loc:tab.esp", Icon = "users-round", ShowTabTitle = true, Border = true})
espTab:Divider({Title = "loc:section.player_visuals"})
espTab:Toggle({
    Title = "loc:toggle.enable_esp",
    Flag = "EspEnable",
    Value = false,
    Callback = function(s)
        espEnabled = s
        pcall(function() if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end end)
    end
})


espTab:Toggle({
    Title = "loc:toggle.show_names",
    Flag = "EspShowNames",
    Value = true,
    Callback = function(s)
        ESP_CONFIG.ShowName = s
        for _, data in pairs(espElements) do
            if data.NameLabel then
                data.NameLabel.Visible = s
            end
        end
    end
})
espTab:Slider({
    Title = "loc:slider.box_transparency",
    Flag = "EspBoxTrans",
    Value = {
        Min = 0,
        Max = 100,
        Default = 85
    },
    Step = 1,
    Callback = function(v)
        ESP_CONFIG.BoxTransparency = v / 100
        for _, data in pairs(espElements) do
            if data.Box then
                data.Box.BackgroundTransparency = ESP_CONFIG.BoxTransparency
            end
        end
    end
})
espTab:Colorpicker({
    Title = "loc:color.box",
    Flag = "EspBoxColor",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(c)
        ESP_CONFIG.BoxColor = c
        for _, data in pairs(espElements) do
            if data.Box then
                data.Box.BackgroundColor3 = ESP_CONFIG.BoxColor
            end
        end
    end
})
espTab:Colorpicker({
    Title = "loc:color.outline",
    Flag = "EspOutlineColor",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(c)
        ESP_CONFIG.OutlineColor = c
        for _, data in pairs(espElements) do
            if data.Box then
                local stroke = data.Box:FindFirstChildOfClass("UIStroke")
                if stroke then
                    stroke.Color = ESP_CONFIG.OutlineColor
                end
            end
        end
    end
})
espTab:Colorpicker({
    Title = "loc:color.text",
    Flag = "EspTextColor",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(c)
        ESP_CONFIG.TextColor = c
        for _, data in pairs(espElements) do
            if data.NameLabel then
                data.NameLabel.TextColor3 = ESP_CONFIG.TextColor
            end
        end
    end
})
espTab:Slider({
    Title = "loc:slider.outline_thickness",
    Flag = "EspOutlineThick",
    Value = {
        Min = 0.5,
        Max = 5,
        Default = 1.5
    },
    Step = 0.1,
    Callback = function(v)
        ESP_CONFIG.OutlineThickness = v
        for _, data in pairs(espElements) do
            if data.Box then
                local stroke = data.Box:FindFirstChildOfClass("UIStroke")
                if stroke then
                    stroke.Thickness = ESP_CONFIG.OutlineThickness
                end
            end
        end
    end
})

end)()

;(function()
local originalSky = Lighting:FindFirstChildOfClass("Sky") and Lighting:FindFirstChildOfClass("Sky"):Clone() or nil
local originalAtmospheres = {}
for _, object in ipairs(Lighting:GetChildren()) do
    if object:IsA("Atmosphere") then
        table.insert(originalAtmospheres, object:Clone())
    end
end
local terrain = workspace:FindFirstChildOfClass("Terrain")
local originalClouds = terrain and terrain:FindFirstChildOfClass("Clouds") and terrain:FindFirstChildOfClass("Clouds"):Clone() or nil
originalLightingState = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    ExposureCompensation = Lighting.ExposureCompensation,
    FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd,
    FogColor = Lighting.FogColor,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ColorShift_Top = Lighting.ColorShift_Top,
    ColorShift_Bottom = Lighting.ColorShift_Bottom,
    EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
    EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
    ShadowSoftness = Lighting.ShadowSoftness,
    GlobalShadows = Lighting.GlobalShadows
}
originalPostEffects = {}
for _, object in ipairs(Lighting:GetChildren()) do
    if object:IsA("BloomEffect") or object:IsA("ColorCorrectionEffect") or object:IsA("SunRaysEffect") or object:IsA("DepthOfFieldEffect") then
        table.insert(originalPostEffects, object:Clone())
    end
end
skyboxData = {
    Twilight = {"264908339", "264907909", "264909420", "264909758", "264908886", "264907379"},
    Nebula = {"159454299", "159454296", "159454293", "159454286", "159454300", "159454288"},
    Vaporwave = {"1417494030", "1417494146", "1417494253", "1417494402", "1417494499", "1417494643"},
    Redshift = {"401664839", "401664862", "401664960", "401664881", "401664901", "401664936"},
    ["Blue Stars"] = {"149397684", "149397686", "149397688", "149397692", "149397697", "149397702"},
    ["Sakura Pink Sky"] = {"271042516", "271077243", "271042556", "271042310", "271042467", "271077958"},
    Default = {"591058823", "591059876", "591058104", "591057861", "591057625", "591059642"},
    Desert = {"1013852", "1013853", "1013850", "1013851", "1013849", "1013854"},
    DaBaby = {"7245418472", "7245418472", "7245418472", "7245418472", "7245418472", "7245418472"},
    Minecraft = {"1876545003", "1876544331", "1876542941", "1876543392", "1876543764", "1876544642"},
    SpongeBob = {"7633178166", "7633178166", "7633178166", "7633178166", "7633178166", "7633178166"},
    Skibidi = {"14952256113", "14952256113", "14952256113", "14952256113", "14952256113", "14952256113"},
    Blaze = {"150939022", "150939038", "150939047", "150939056", "150939063", "150939082"},
    ["Pussy Cat"] = {"11154422902", "11154422902", "11154422902", "11154422902", "11154422902", "11154422902"},
    ["Among Us"] = {"5752463190", "5752463190", "5752463190", "5752463190", "5752463190", "5752463190"},
    ["Space Wave"] = {"16262356578", "16262358026", "16262360469", "16262362003", "16262363873", "16262366016"},
    ["Space Wave 2"] = {"1233158420", "1233158838", "1233157105", "1233157640", "1233157995", "1233159158"},
    ["Turquoise Wave"] = {"47974894", "47974690", "47974821", "47974776", "47974859", "47974909"},
    ["Dark Night"] = {"6285719338", "6285721078", "6285722964", "6285724682", "6285726335", "6285730635"},
    ["White Galaxy"] = {"5540798456", "5540799894", "5540801779", "5540801192", "5540799108", "5540800635"}
}
downloadedSkyboxFaceMaps = {
    Evernight = {
        SkyboxBk = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_RT.png",
        SkyboxDn = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_DN.png",
        SkyboxFt = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_FT.png",
        SkyboxLf = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_BK.png",
        SkyboxRt = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_LF.png",
        SkyboxUp = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_UP.png"
    },
    ["Hakari Hananozo"] = {
        SkyboxBk = "https://od.lk/d/NjNfOTg0NjEzMTVf/SkyBk.tex",
        SkyboxDn = "https://od.lk/d/NjNfOTg0NjEzMTZf/Skydn.tex",
        SkyboxFt = "https://od.lk/s/NjNfOTg0NjEzMTdf/SkyFt.tex",
        SkyboxLf = "https://od.lk/s/NjNfOTg0NjEzMThf/SkyIf.tex",
        SkyboxRt = "https://od.lk/d/NjNfOTg0NjEzMTlf/SkyRt.tex",
        SkyboxUp = "https://od.lk/d/NjNfOTg0NjEzMjBf/SkyUp.tex"
    },
    ItsukiNakano = {
        SkyboxBk = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Bk.png",
        SkyboxDn = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Dn.png",
        SkyboxFt = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Ft.png",
        SkyboxLf = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Lf.png",
        SkyboxRt = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Rt.png",
        SkyboxUp = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Up.png"
    },
    ItsukiNakano2 = {
        SkyboxBk = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Bk.png",
        SkyboxDn = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Dn.png",
        SkyboxFt = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Ft.png",
        SkyboxLf = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Lf.png",
        SkyboxRt = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Rt.png",
        SkyboxUp = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Up.png"
    },
    MaiSakurajima = {
        SkyboxBk = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/back.png",
        SkyboxDn = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/down.png",
        SkyboxFt = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/front.png",
        SkyboxLf = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/left.png",
        SkyboxRt = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/right.png",
        SkyboxUp = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/top.png"
    },
    MikuNakano = {
        SkyboxBk = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Bk.png",
        SkyboxDn = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Dn.png",
        SkyboxFt = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Ft.png",
        SkyboxLf = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Lf.png",
        SkyboxRt = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Rt.png",
        SkyboxUp = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Up.png"
    },
    ["Nino Nakano"] = {
        SkyboxBk = "https://od.lk/d/NjNfOTg0NjQyODJf/left1.png",
        SkyboxDn = "https://od.lk/d/NjNfOTg0NjQyNzlf/down.png",
        SkyboxFt = "https://od.lk/d/NjNfOTg0NjQyODBf/front.png",
        SkyboxLf = "https://od.lk/d/NjNfOTg0NjQyNzhf/back.png",
        SkyboxRt = "https://od.lk/d/NjNfOTg0NjQyODNf/right1.png",
        SkyboxUp = "https://od.lk/d/NjNfOTg0NjQyODFf/up.png"
    },
    ["Nino Nakano 2"] = {
        SkyboxBk = "https://od.lk/d/NjNfOTg0NjQyNTNf/if.png",
        SkyboxDn = "https://od.lk/d/NjNfOTg0NjQyNTVf/dn.png",
        SkyboxFt = "https://od.lk/d/NjNfOTg0NjQyNTZf/bk.png",
        SkyboxLf = "https://od.lk/d/NjNfOTg0NjQyNTRf/ft.png",
        SkyboxRt = "https://od.lk/d/NjNfOTg0NjQyNTJf/rt.png",
        SkyboxUp = "https://od.lk/d/NjNfOTg0NjQyNTBf/up.png"
    },
    ["Rias Gremory"] = {
        SkyboxBk = "https://od.lk/d/NjNfOTg0NzkyOTNf/leftRias.png",
        SkyboxDn = "https://od.lk/d/NjNfOTg0NzkyOThf/downRias.png",
        SkyboxFt = "https://od.lk/d/NjNfOTg0NzkyOTVf/front%20Rias.png",
        SkyboxLf = "https://od.lk/d/NjNfOTg0NzkyOTRf/BackRias.png",
        SkyboxRt = "https://od.lk/d/NjNfOTg0NzkyOTFf/RightRias.png",
        SkyboxUp = "https://od.lk/d/NjNfOTg0NzkyOTJf/UpRias.png"
    },
    ["Saki Saki"] = {
        SkyboxBk = "https://od.lk/d/NjNfOTg0NjQyNjZf/back1.png",
        SkyboxDn = "https://od.lk/d/NjNfOTg0NjQyNjdf/down1.png",
        SkyboxFt = "https://od.lk/d/NjNfOTg0NjQyNjhf/front1.png",
        SkyboxLf = "https://od.lk/d/NjNfOTg0NjQyNzBf/left.png",
        SkyboxRt = "https://od.lk/d/NjNfOTg0NjQyNzNf/right.png",
        SkyboxUp = "https://od.lk/d/NjNfOTg0NjQyNjlf/Up1.png"
    },
    Waguri = {
        SkyboxBk = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_ft.png",
        SkyboxDn = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_dn.png",
        SkyboxFt = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_bk.png",
        SkyboxLf = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_rt.png",
        SkyboxRt = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_lf.png",
        SkyboxUp = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_up.png"
    },
    ["Xenovia Quarta"] = {
        SkyboxBk = "https://od.lk/d/NjNfOTg0NjM0ODlf/ft.png",
        SkyboxDn = "https://od.lk/d/NjNfOTg0NjM0OTBf/dn.png",
        SkyboxFt = "https://od.lk/d/NjNfOTg0NjM0OTFf/bk.png",
        SkyboxLf = "https://od.lk/d/NjNfOTg0NjM0ODhf/if.png",
        SkyboxRt = "https://od.lk/d/NjNfOTg0NjM0ODdf/rt.png",
        SkyboxUp = "https://od.lk/d/NjNfOTg0NjM0ODZf/up.png"
    },
    ["Yotsuba Nakano"] = {
        SkyboxBk = "https://od.lk/d/NjNfOTg0NzkzMzFf/YotsubaBk.png",
        SkyboxDn = "https://od.lk/d/NjNfOTg0NzkzMzNf/YotsubaDn.png",
        SkyboxFt = "https://od.lk/d/NjNfOTg0NzkzMzRf/YotsubaFt.png",
        SkyboxLf = "https://od.lk/d/NjNfOTg0NzkzMzZf/YotsubaLeft.png",
        SkyboxRt = "https://od.lk/d/NjNfOTg0NzkzMzdf/YotsubaRt.png",
        SkyboxUp = "https://od.lk/d/NjNfOTg0NzkzMzhf/YotsubaUp.png"
    },
    Alya = {
        SkyboxBk = "https://od.lk/d/NjNfOTg0NzkzMTFf/bk.png",
        SkyboxDn = "https://od.lk/d/NjNfOTg0NzkzMTJf/dn.png",
        SkyboxFt = "https://od.lk/d/NjNfOTg0NzkzMTNf/ft.png",
        SkyboxLf = "https://od.lk/d/NjNfOTg0NzkzMTRf/if.png",
        SkyboxRt = "https://od.lk/d/NjNfOTg0NzkzMTZf/Rt.png",
        SkyboxUp = "https://od.lk/d/NjNfOTg0NzkzMTVf/Up.png"
    },
    ["Alya 2"] = {
        SkyboxBk = "https://od.lk/d/NjNfOTg0NzkzMjBf/AlyaBk.png",
        SkyboxDn = "https://od.lk/d/NjNfOTg0NzkzMjFf/alyaDn.png",
        SkyboxFt = "https://od.lk/d/NjNfOTg0NzkzMjJf/AlyaFt.png",
        SkyboxLf = "https://od.lk/d/NjNfOTg0NzkzMjNf/AlyaLf.png",
        SkyboxRt = "https://od.lk/d/NjNfOTg0NzkzMjRf/AlyaRt.png",
        SkyboxUp = "https://od.lk/d/NjNfOTg0NzkzMjVf/AlyaUp.png"
    }
}
skyboxOrder = {"SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp"}
skyboxNames = {"Original"}
for name in pairs(skyboxData) do
    table.insert(skyboxNames, name)
end
for name in pairs(downloadedSkyboxFaceMaps) do
    table.insert(skyboxNames, name)
end
table.sort(skyboxNames, function(a, b)
    if a == "Original" then return true end
    if b == "Original" then return false end
    return a < b
end)
ContentProvider = game:GetService("ContentProvider")
customAsset = getcustomasset or getsynasset or get_custom_asset

skyboxRequestId = 0
skyboxApplying = false
skyboxReadyFlag = nil

function clearSkyboxes()
    for _, object in ipairs(Lighting:GetChildren()) do
        if object:IsA("Sky") then
            for _, property in ipairs(skyboxOrder) do
                pcall(function()
                    object[property] = ""
                end)
            end
            object.Parent = nil
            pcall(function() object:Destroy() end)
        elseif object:IsA("Atmosphere") then
            pcall(function() object:Destroy() end)
        end
    end
    if terrain then
        for _, object in ipairs(terrain:GetChildren()) do
            if object:IsA("Clouds") then
                pcall(function() object:Destroy() end)
            end
        end
    end
end

function restoreSkybox()
    skyboxRequestId = skyboxRequestId + 1
    skyboxReadyFlag = nil
    clearSkyboxes()
    if originalSky then
        originalSky:Clone().Parent = Lighting
    end
    for _, atmosphere in ipairs(originalAtmospheres) do
        atmosphere:Clone().Parent = Lighting
    end
    if originalClouds and terrain then
        originalClouds:Clone().Parent = terrain
    end
    skyboxReadyFlag = "Original"
end

function safeFileName(name)
    return (name or "skybox"):gsub("[^%w%-_]+", "_"):gsub("_+", "_"):gsub("^_+", ""):gsub("_+$", "")
end

function applySkybox(name, requestId)
    if not requestId or requestId ~= skyboxRequestId then
        return false
    end
    if name == "Original" then
        restoreSkybox()
        return true
    end
    local data = skyboxData[name]
    local remoteData = downloadedSkyboxFaceMaps[name]
    if not data and not remoteData then
        return false
    end
    local sky = Instance.new("Sky")
    sky.Name = "DMVS_Skybox"
    sky.CelestialBodiesShown = false
    sky.StarCount = 0
    if data then
        for index, property in ipairs(skyboxOrder) do
            sky[property] = "rbxassetid://" .. data[index]
        end
    else
        if not writefile or not isfile or not isfolder or not makefolder or not customAsset then
            notify({MessageKey = "notification.skybox_file", Type = "warning"})
            sky:Destroy()
            return false
        end
        if not isfolder("DMVS") then makefolder("DMVS") end
        if not isfolder("DMVS/skyboxes_v4") then makefolder("DMVS/skyboxes_v4") end
        local folder = "DMVS/skyboxes_v4"
        local safe = safeFileName(name)
        local pending = #skyboxOrder
        local failed = false
        local results = {}
        for _, property in ipairs(skyboxOrder) do
            task.spawn(function()
                if failed or requestId ~= skyboxRequestId then
                    pending = pending - 1
                    return
                end
                local faceUrl = remoteData[property]
                if type(faceUrl) ~= "string" or faceUrl == "" then
                    failed = true
                    pending = pending - 1
                    return
                end
                local path = folder .. "/" .. safe .. "_" .. property .. ".png"
                if not isfile(path) then
                    local success, body = pcall(function()
                        return game:HttpGet(faceUrl, true)
                    end)
                    if not success or type(body) ~= "string" or #body < 32 then
                        failed = true
                        pending = pending - 1
                        return
                    end
                    writefile(path, body)
                end
                results[property] = path
                pending = pending - 1
            end)
        end
        while pending > 0 do
            task.wait()
        end
        if failed then
            sky:Destroy()
            notify({MessageKey = "notification.skybox_download", Args = {name}, Type = "error"})
            return false
        end
        for _, property in ipairs(skyboxOrder) do
            if requestId ~= skyboxRequestId then
                sky:Destroy()
                return false
            end
            local assetSuccess, assetId = pcall(customAsset, results[property])
            if not assetSuccess or type(assetId) ~= "string" or assetId == "" then
                sky:Destroy()
                notify({MessageKey = "notification.skybox_register", Args = {property, name}, Type = "error"})
                return false
            end
            sky[property] = assetId
        end
    end
    if requestId ~= skyboxRequestId then
        sky:Destroy()
        return false
    end
    local preloadSuccess = pcall(function()
        ContentProvider:PreloadAsync({sky})
    end)
    if not preloadSuccess then
        sky:Destroy()
        notify({MessageKey = "notification.skybox_preload", Args = {name}, Type = "error"})
        return false
    end
    if requestId ~= skyboxRequestId then
        sky:Destroy()
        return false
    end
    clearSkyboxes()
    if requestId ~= skyboxRequestId then
        sky:Destroy()
        return false
    end
    sky.Parent = Lighting
    skyboxReadyFlag = name
    return true
end

function requestSkybox(name)
    skyboxRequestId = skyboxRequestId + 1
    local requestId = skyboxRequestId
    skyboxReadyFlag = nil
    task.spawn(function()
        if skyboxApplying then
            return
        end
        skyboxApplying = true
        local ok = applySkybox(name, requestId)
        skyboxApplying = false
        if ok and requestId == skyboxRequestId then
            notify({MessageKey = "notification.skybox_changed", Args = {name}, Type = "done"})
        end
    end)
end

rtxPresets = {
    Cinematic = {
        Brightness = 2,
        Exposure = -0.05,
        ClockTime = 17.4,
        Ambient = Color3.fromRGB(72, 72, 82),
        OutdoorAmbient = Color3.fromRGB(100, 93, 112),
        Bloom = {Intensity = 0.55, Size = 40, Threshold = 1},
        Color = {Brightness = -0.01, Contrast = 0.28, Saturation = -0.08, TintColor = Color3.fromRGB(255, 225, 205)},
        Rays = {Intensity = 0.12, Spread = 0.8},
        Depth = {FarIntensity = 0.08, FocusDistance = 45, InFocusRadius = 32, NearIntensity = 0.15}
    },
    Performance = {
        Brightness = 2,
        Exposure = 0,
        ClockTime = 14,
        Ambient = Color3.fromRGB(100, 100, 100),
        OutdoorAmbient = Color3.fromRGB(128, 128, 128),
        Color = {Brightness = 0, Contrast = 0.08, Saturation = 0.05, TintColor = Color3.fromRGB(255, 255, 255)}
    }
}

function clearPostEffects()
    for _, object in ipairs(Lighting:GetChildren()) do
        if object:IsA("BloomEffect") or object:IsA("ColorCorrectionEffect") or object:IsA("SunRaysEffect") or object:IsA("DepthOfFieldEffect") then
            object:Destroy()
        end
    end
end

function applyProperties(object, properties)
    for property, value in pairs(properties) do
        object[property] = value
    end
end

function restoreRTX()
    clearPostEffects()
    for property, value in pairs(originalLightingState) do
        Lighting[property] = value
    end
    for _, effect in ipairs(originalPostEffects) do
        effect:Clone().Parent = Lighting
    end
end

function applyRTX(name)
    if name == "Original" then
        restoreRTX()
        return
    end
    local preset = rtxPresets[name]
    if not preset then return end
    clearPostEffects()
    Lighting.Brightness = preset.Brightness
    Lighting.ExposureCompensation = preset.Exposure
    Lighting.ClockTime = preset.ClockTime
    Lighting.Ambient = preset.Ambient
    Lighting.OutdoorAmbient = preset.OutdoorAmbient
    Lighting.EnvironmentDiffuseScale = 1
    Lighting.EnvironmentSpecularScale = 1
    Lighting.ShadowSoftness = 0.18
    Lighting.GlobalShadows = true
    if preset.Bloom then
        local effect = Instance.new("BloomEffect")
        applyProperties(effect, preset.Bloom)
        effect.Name = "DMVS_RTX_Bloom"
        effect.Parent = Lighting
    end
    if preset.Color then
        local effect = Instance.new("ColorCorrectionEffect")
        applyProperties(effect, preset.Color)
        effect.Name = "DMVS_RTX_Color"
        effect.Parent = Lighting
    end
    if preset.Rays then
        local effect = Instance.new("SunRaysEffect")
        applyProperties(effect, preset.Rays)
        effect.Name = "DMVS_RTX_Rays"
        effect.Parent = Lighting
    end
    if preset.Depth then
        local effect = Instance.new("DepthOfFieldEffect")
        applyProperties(effect, preset.Depth)
        effect.Name = "DMVS_RTX_Depth"
        effect.Parent = Lighting
    end
end

nameState = {
    myUsernameEnabled = false,
    otherNamesEnabled = false,
    replacementName = "FlexusHub",
    playerNameMap = {},
    fakeNames = {},
    playerConnections = {},
    nextFakeNameId = 1,
    trackedElements = setmetatable({}, {__mode = "k"}),
    originalTextByElement = setmetatable({}, {__mode = "k"}),
    renderedTextByElement = setmetatable({}, {__mode = "k"}),
    elementConnections = setmetatable({}, {__mode = "k"}),
    elementUpdating = setmetatable({}, {__mode = "k"}),
    containerConnections = {},
    cachedReplacementPairs = nil
}

function invalidateNameReplacementCache()
    nameState.cachedReplacementPairs = nil
end

function escapeNamePattern(text)
    return string.gsub(text, "([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
end

function isNameTextElement(element)
    return element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox")
end

function rebuildOtherPlayerNameMap()
    nameState.playerNameMap = {}
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player then
            local fakeName = nameState.fakeNames[targetPlayer]
            if not fakeName then
                fakeName = "FlexusHub #" .. tostring(nameState.nextFakeNameId)
                nameState.nextFakeNameId = nameState.nextFakeNameId + 1
                nameState.fakeNames[targetPlayer] = fakeName
            end
            if targetPlayer.Name and targetPlayer.Name ~= "" then
                nameState.playerNameMap[targetPlayer.Name] = fakeName
            end
            if targetPlayer.DisplayName and targetPlayer.DisplayName ~= "" then
                nameState.playerNameMap[targetPlayer.DisplayName] = fakeName
            end
        end
    end
    invalidateNameReplacementCache()
end

function getNameReplacementPairs()
    if nameState.cachedReplacementPairs then
        return nameState.cachedReplacementPairs
    end
    local replacements = {}
    local seen = {}
    local function addReplacement(originalName, fakeName)
        if originalName and originalName ~= "" and not seen[originalName] then
            seen[originalName] = true
            table.insert(replacements, {Original = originalName, Replacement = fakeName})
        end
    end

    if nameState.myUsernameEnabled then
        addReplacement(player.Name, nameState.replacementName)
        addReplacement(player.DisplayName, nameState.replacementName)
    end
    if nameState.otherNamesEnabled then
        for originalName, fakeName in pairs(nameState.playerNameMap) do
            addReplacement(originalName, fakeName)
        end
    end

    table.sort(replacements, function(left, right)
        return #left.Original > #right.Original
    end)
    nameState.cachedReplacementPairs = replacements
    return nameState.cachedReplacementPairs
end

function transformNameText(text)
    local transformedText = text
    for _, replacement in ipairs(getNameReplacementPairs()) do
        transformedText = string.gsub(transformedText, escapeNamePattern(replacement.Original), replacement.Replacement)
    end
    return transformedText
end

function refreshNameElement(element)
    if not element or not element.Parent or not isNameTextElement(element) or nameState.elementUpdating[element] then
        return
    end

    local currentText = element.Text
    local originalText = nameState.originalTextByElement[element]
    local renderedText = nameState.renderedTextByElement[element]
    if originalText == nil then
        originalText = currentText
    elseif renderedText ~= nil and currentText ~= renderedText then
        originalText = currentText
    end
    nameState.originalTextByElement[element] = originalText

    local transformedText = transformNameText(originalText)
    nameState.renderedTextByElement[element] = transformedText
    if element.Text ~= transformedText then
        nameState.elementUpdating[element] = true
        pcall(function()
            element.Text = transformedText
        end)
        nameState.elementUpdating[element] = nil
    end
end

function refreshAllNameElements()
    for element in pairs(nameState.trackedElements) do
        refreshNameElement(element)
    end
end

function trackNameElement(element)
    if not element or not element.Parent or not isNameTextElement(element) then
        return
    end
    nameState.trackedElements[element] = true
    if not nameState.elementConnections[element] then
        nameState.elementConnections[element] = element:GetPropertyChangedSignal("Text"):Connect(function()
            refreshNameElement(element)
        end)
    end
    refreshNameElement(element)
end

function scanNameContainer(container)
    if not container or nameState.containerConnections[container] then
        return
    end
    for _, element in ipairs(container:GetDescendants()) do
        trackNameElement(element)
    end
    nameState.containerConnections[container] = container.DescendantAdded:Connect(trackNameElement)
end

function registerOtherPlayer(targetPlayer)
    if targetPlayer == player then
        return
    end
    if not nameState.fakeNames[targetPlayer] then
        nameState.fakeNames[targetPlayer] = "FlexusHub #" .. tostring(nameState.nextFakeNameId)
        nameState.nextFakeNameId = nameState.nextFakeNameId + 1
    end
    if not nameState.playerConnections[targetPlayer] then
        nameState.playerConnections[targetPlayer] = targetPlayer:GetPropertyChangedSignal("DisplayName"):Connect(function()
            rebuildOtherPlayerNameMap()
            refreshAllNameElements()
        end)
    end
end

for _, targetPlayer in ipairs(Players:GetPlayers()) do
    registerOtherPlayer(targetPlayer)
end
rebuildOtherPlayerNameMap()
Players.PlayerAdded:Connect(function(targetPlayer)
    registerOtherPlayer(targetPlayer)
    rebuildOtherPlayerNameMap()
    refreshAllNameElements()
end)
Players.PlayerRemoving:Connect(function(targetPlayer)
    nameState.fakeNames[targetPlayer] = nil
    nameState.playerNameMap[targetPlayer.Name] = nil
    nameState.playerNameMap[targetPlayer.DisplayName] = nil
    invalidateNameReplacementCache()
    local connection = nameState.playerConnections[targetPlayer]
    if connection then
        connection:Disconnect()
        nameState.playerConnections[targetPlayer] = nil
    end
    refreshAllNameElements()
end)

nameChangeContainers = {
    playerGui,
    game:GetService("CoreGui"),
    workspace
}
for _, container in ipairs(nameChangeContainers) do
    task.spawn(function()
        pcall(function()
            scanNameContainer(container)
        end)
    end)
end


-- ==========================================
-- MOVEMENT TAB (VXS) - Speed / Fly / Inf Jump / Tela / Noclip
-- ==========================================

-- Movement helpers (spoof WalkSpeed + random names)
local spoofedWalkSpeeds = spoofedWalkSpeeds or {}
local function _gameLikeName()
    local prefixes = { "Core", "Player", "Camera", "Input", "Render", "UI", "Hud", "Badge", "Prompt" }
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local s = prefixes[math.random(1, #prefixes)]
    for _ = 1, 8 do
        local i = math.random(1, #chars)
        s = s .. chars:sub(i, i)
    end
    return s
end
-- WalkSpeed index spoof (solo lectura protegida si hay metamethods)
pcall(function()
    if not getgenv().FlexusWalkSpeedHook then
        getgenv().FlexusWalkSpeedHook = true
        if hookmetamethod and newcclosure then
            local oldIndex
            oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
                if key == "WalkSpeed" and spoofedWalkSpeeds[self] ~= nil and not checkcaller() then
                    return spoofedWalkSpeeds[self]
                end
                return oldIndex(self, key)
            end))
        end
    end
end)

-- MOVEMENT TAB (Popular) - Speed / Fly / Inf Jump con spoof
-- ==========================================
local movementTab = Window:Tab({ Title = "Movement", Icon = "zap", ShowTabTitle = true, Border = true })

local moveSpeedEnabled = false
local moveSpeedValue = 28
local moveFlyEnabled = false
local moveFlySpeed = 80
local moveInfJumpEnabled = false
local moveNoclipEnabled = false
local moveNoclipConn = nil
local moveSpeedGlitchEnabled = false
local moveSpeedGlitchConn = nil
local moveGlitchJumpConn = nil
local moveFlyBV, moveFlyBG = nil, nil
local moveConns = {}

local function moveGetChar()
    return player.Character
end

local function moveGetHum()
    local c = moveGetChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function moveGetRoot()
    local c = moveGetChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function setProtectedWalkSpeed(hum, realSpeed)
    if not hum then return end
    -- Valor real alto; a scripts/AC que lean sin checkcaller les devolvemos 16
    if not spoofedWalkSpeeds[hum] then
        spoofedWalkSpeeds[hum] = 16
    end
    pcall(function()
        hum.WalkSpeed = realSpeed
    end)
end

local function clearWalkSpeedSpoof(hum)
    if hum and spoofedWalkSpeeds[hum] then
        spoofedWalkSpeeds[hum] = nil
        pcall(function()
            if hum.Parent then hum.WalkSpeed = 16 end
        end)
    end
end

local function stopFlyMovers()
    if moveFlyBV then pcall(function() moveFlyBV:Destroy() end) moveFlyBV = nil end
    if moveFlyBG then pcall(function() moveFlyBG:Destroy() end) moveFlyBG = nil end
    local hum = moveGetHum()
    if hum then
        pcall(function()
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end)
    end
end

local function startFlyMovers()
    stopFlyMovers()
    local root = moveGetRoot()
    if not root then return end
    local ok = pcall(function()
        local bv = Instance.new("BodyVelocity")
        bv.Name = _gameLikeName()
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.zero
        bv.Parent = root
        moveFlyBV = bv
        local bg = Instance.new("BodyGyro")
        bg.Name = _gameLikeName()
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.P = 9e4
        bg.CFrame = root.CFrame
        bg.Parent = root
        moveFlyBG = bg
    end)
    if not ok then stopFlyMovers() end
end

movementTab:Section({ Title = "Movimiento protegido" })
movementTab:Paragraph({
    Title = "Aviso",
    Desc = "Speed usa spoof de WalkSpeed. Fly e Inf Jump usan nombres random. Aun asi el server puede detectar movimiento raro."
})

-- Movimiento Tela: va donde apunta el joystick pero con inclinacion/strafe exagerado
local telaEnabled = false
local telaSpeed = 42
local telaLean = 0
local telaConn = nil
local telaRenderConn = nil

local function stopTela()
    if telaConn then
        pcall(function() telaConn:Disconnect() end)
        telaConn = nil
    end
    if telaRenderConn then
        pcall(function() telaRenderConn:Disconnect() end)
        telaRenderConn = nil
    end
    telaLean = 0
    pcall(function()
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root and root.Parent then
            -- no forzar CFrame raro al apagar
        end
    end)
end

local function startTela()
    stopTela()
    -- Heartbeat: empuje fuerte hacia MoveDirection (joystick)
    telaConn = RunService.Heartbeat:Connect(function(dt)
        if not telaEnabled then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end
        if hum.Sit or hum.PlatformStand then return end

        local move = hum.MoveDirection
        if move.Magnitude < 0.05 then
            -- frenado suave
            local vel = root.AssemblyLinearVelocity
            root.AssemblyLinearVelocity = Vector3.new(vel.X * 0.86, vel.Y, vel.Z * 0.86)
            telaLean = telaLean * 0.85
            return
        end

        local dir = move.Unit
        local target = dir * telaSpeed
        local vel = root.AssemblyLinearVelocity
        local blend = math.clamp(dt * 16, 0, 1)
        -- empuje agresivo (se siente que "tira" mucho)
        local nx = vel.X + (target.X - vel.X) * blend
        local nz = vel.Z + (target.Z - vel.Z) * blend
        -- boost extra para que se note el desplazamiento
        nx = nx + dir.X * (telaSpeed * 0.12)
        nz = nz + dir.Z * (telaSpeed * 0.12)
        root.AssemblyLinearVelocity = Vector3.new(nx, vel.Y, nz)

        -- lean lateral: cruza el vector de movimiento con up para inclinarse de lado
        local side = dir:Cross(Vector3.yAxis)
        if side.Magnitude > 0.01 then
            side = side.Unit
            local sideAmt = math.clamp(dir:Dot(root.CFrame.RightVector), -1, 1)
            telaLean = telaLean + (sideAmt - telaLean) * math.clamp(dt * 10, 0, 1)
        else
            telaLean = telaLean * 0.9
        end
    end)

    -- Render: inclina el personaje hacia un lado mientras avanza (look hacia el joystick)
    telaRenderConn = RunService.RenderStepped:Connect(function(dt)
        if not telaEnabled then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end
        if hum.Sit or hum.PlatformStand then return end

        local move = hum.MoveDirection
        if move.Magnitude < 0.08 then return end

        local dir = Vector3.new(move.X, 0, move.Z)
        if dir.Magnitude < 0.05 then return end
        dir = dir.Unit

        -- mira hacia donde apunta el joystick
        local lookCF = CFrame.new(root.Position, root.Position + dir)
        -- inclina el torso visualmente (roll) hacia el lado del strafe
        local leanAngle = math.rad(-18 * telaLean) -- se ve cargado a un lado
        local tilt = CFrame.Angles(math.rad(-6), 0, leanAngle) -- leve hacia adelante + roll
        root.CFrame = lookCF * tilt
    end)
end

movementTab:Toggle({
    Flag = "Movimiento_Tela",
    Title = "Movimiento Tela",
    Desc = "Vas donde apunta el joystick con empuje fuerte e inclinacion lateral (estilo tela).",
    Default = false,
    Callback = function(state)
        telaEnabled = state and true or false
        if state then
            startTela()
            pcall(function() notify({ Title = "Movement", Content = "Movimiento Tela: ON", Duration = 2 }) end)
        else
            stopTela()
            pcall(function() notify({ Title = "Movement", Content = "Movimiento Tela: OFF", Duration = 2 }) end)
        end
    end
})

movementTab:Slider({
    Flag = "Velocidad_Tela",
    Title = "Velocidad Tela",
    Desc = "Que tan fuerte empuja el movimiento tela.",
    Value = { Min = 24, Max = 80, Default = 42 },
    Callback = function(v)
        telaSpeed = tonumber(v) or 42
    end
})


movementTab:Toggle({
    Flag = "Velocidad_Speed",
    Title = "Velocidad (Speed)",
    Desc = "Aumenta tu velocidad de movimiento (con spoof anti-deteccion).",
    Default = false,
    Callback = function(state)
        moveSpeedEnabled = state
        local hum = moveGetHum()
        if state then
            -- apaga glitch para no chocar
            if moveSpeedGlitchEnabled then
                moveSpeedGlitchEnabled = false
                if moveSpeedGlitchConn then moveSpeedGlitchConn:Disconnect(); moveSpeedGlitchConn = nil end
                if moveGlitchJumpConn then moveGlitchJumpConn:Disconnect(); moveGlitchJumpConn = nil end
            end
            setProtectedWalkSpeed(hum, moveSpeedValue)
        else
            clearWalkSpeedSpoof(hum)
        end
        pcall(function() notify({ Title = "Movement", Content = tostring(state and ("Speed ON: " .. tostring(moveSpeedValue), Duration = 2 }) end)) or "Speed OFF")
    end
})

movementTab:Slider({
    Flag = "Valor_de_velocidad",
    Title = "Valor de velocidad",
    Desc = "Que tan rapido te mueves con Speed activo.",
    Value = { Min = 16, Max = 120, Default = 28 },
    Callback = function(v)
        moveSpeedValue = v
        if moveSpeedEnabled then
            setProtectedWalkSpeed(moveGetHum(), moveSpeedValue)
        end
    end
})

movementTab:Toggle({
    Flag = "Vuelo_Fly",
    Title = "Vuelo (Fly)",
    Desc = "Te permite volar libremente por el mapa.",
    Default = false,
    Callback = function(state)
        moveFlyEnabled = state
        if state then
            startFlyMovers()
        else
            stopFlyMovers()
        end
        pcall(function() notify({ Title = "Movement", Content = tostring(state and "Fly ON" or "Fly OFF"), Duration = 2 }) end)
    end
})

movementTab:Slider({
    Flag = "Velocidad_de_vuelo",
    Title = "Velocidad de vuelo",
    Desc = "Velocidad al usar Fly.",
    Value = { Min = 20, Max = 250, Default = 80 },
    Callback = function(v)
        moveFlySpeed = v
    end
})

movementTab:Toggle({
    Flag = "Salto_infinito",
    Title = "Salto infinito",
    Desc = "Puedes saltar sin limite en el aire.",
    Default = false,
    Callback = function(state)
        moveInfJumpEnabled = state
        pcall(function() notify({ Title = "Movement", Content = tostring(state and "Inf Jump ON" or "Inf Jump OFF"), Duration = 2 }) end)
    end
})

-- Noclip
movementTab:Toggle({
    Flag = "Noclip",
    Title = "Noclip",
    Desc = "Atraviesa paredes y objetos del mapa.",
    Default = false,
    Callback = function(state)
        moveNoclipEnabled = state
        if state then
            if not moveNoclipConn then
                moveNoclipConn = RunService.Stepped:Connect(function()
                    if not moveNoclipEnabled then return end
                    local char = moveGetChar()
                    if not char then return end
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end)
            end
            pcall(function() notify({ Title = "Movement", Content = "Noclip ON", Duration = 2 }) end)
        else
            if moveNoclipConn then
                moveNoclipConn:Disconnect()
                moveNoclipConn = nil
            end
            pcall(function() notify({ Title = "Movement", Content = "Noclip OFF", Duration = 2 }) end)
        end
    end
})

-- Glitch de velocidad (igual que MM2: velocidad en aire, 16 en suelo)
movementTab:Toggle({
    Flag = "Glitch_de_Velocidad",
    Title = "Glitch de Velocidad",
    Desc = "Velocidad al saltar/caer; normal en el suelo. Se apaga el Speed permanente.",
    Default = false,
    Callback = function(state)
        moveSpeedGlitchEnabled = state
        if state then
            if moveSpeedEnabled then
                moveSpeedEnabled = false
                clearWalkSpeedSpoof(moveGetHum())
            end
            if not moveGlitchJumpConn then
                moveGlitchJumpConn = UserInputService.JumpRequest:Connect(function()
                    if not moveSpeedGlitchEnabled then return end
                    local hum = moveGetHum()
                    if hum then
                        -- velocidad justo antes de despegar (con spoof)
                        setProtectedWalkSpeed(hum, moveSpeedValue)
                    end
                end)
            end
            if not moveSpeedGlitchConn then
                moveSpeedGlitchConn = RunService.Stepped:Connect(function()
                    if not moveSpeedGlitchEnabled then return end
                    local hum = moveGetHum()
                    if not hum then return end
                    local st = hum:GetState()
                    local inAir = (st == Enum.HumanoidStateType.Jumping or st == Enum.HumanoidStateType.Freefall)
                    if inAir then
                        if hum.WalkSpeed ~= moveSpeedValue then
                            setProtectedWalkSpeed(hum, moveSpeedValue)
                        end
                    else
                        if not moveSpeedEnabled and hum.WalkSpeed ~= 16 then
                            clearWalkSpeedSpoof(hum)
                            pcall(function() hum.WalkSpeed = 16 end)
                        end
                    end
                end)
            end
            pcall(function() notify({ Title = "Movement", Content = "Speed Glitch ON", Duration = 2 }) end)
        else
            if moveSpeedGlitchConn then
                moveSpeedGlitchConn:Disconnect()
                moveSpeedGlitchConn = nil
            end
            if moveGlitchJumpConn then
                moveGlitchJumpConn:Disconnect()
                moveGlitchJumpConn = nil
            end
            if not moveSpeedEnabled then
                clearWalkSpeedSpoof(moveGetHum())
            end
            pcall(function() notify({ Title = "Movement", Content = "Speed Glitch OFF", Duration = 2 }) end)
        end
    end
})

-- Loop movimiento
task.spawn(function()
    while true do
        task.wait(0.05)
        pcall(function()
            if moveSpeedEnabled then
                local hum = moveGetHum()
                if hum and hum.WalkSpeed ~= moveSpeedValue then
                    setProtectedWalkSpeed(hum, moveSpeedValue)
                end
            end
            if moveFlyEnabled then
                local root = moveGetRoot()
                local hum = moveGetHum()
                if root then
                    if not moveFlyBV or moveFlyBV.Parent ~= root then
                        startFlyMovers()
                    end
                    if hum then
                        pcall(function() hum.PlatformStand = true end)
                    end
                    local cam = workspace.CurrentCamera
                    if cam and moveFlyBV then
                        local dir = Vector3.zero
                        if not UserInputService:GetFocusedTextBox() then
                            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
                            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
                            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
                            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
                            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
                            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                                dir -= Vector3.yAxis
                            end
                        end
                        if dir.Magnitude > 0.1 then
                            moveFlyBV.Velocity = dir.Unit * moveFlySpeed
                        else
                            moveFlyBV.Velocity = Vector3.zero
                        end
                        if moveFlyBG then
                            local flat = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
                            if flat.Magnitude > 0.05 then
                                moveFlyBG.CFrame = CFrame.new(root.Position, root.Position + flat)
                            end
                        end
                    end
                end
            end
        end)
    end
end)

table.insert(moveConns, UserInputService.JumpRequest:Connect(function()
    if not moveInfJumpEnabled then return end
    local hum = moveGetHum()
    if hum then
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end
end))

player.CharacterAdded:Connect(function()
    task.wait(0.4)
    if moveSpeedEnabled then
        setProtectedWalkSpeed(moveGetHum(), moveSpeedValue)
    end
    if moveFlyEnabled then
        startFlyMovers()
    end
end)


local customTab = Window:Tab({Title = "Custom", Icon = "sparkles", ShowTabTitle = true, Border = true})
customTab:Divider({Title = "Visual"})
customTab:Divider({Title = "loc:section.change_names"})
customTab:Toggle({
    Title = "loc:toggle.change_my_username",
    Flag = "ChangeMyUsername",
    Value = false,
    Callback = function(value)
        nameState.myUsernameEnabled = value
        invalidateNameReplacementCache()
        refreshAllNameElements()
    end
})
customTab:Toggle({
    Title = "loc:toggle.change_other_names",
    Flag = "ChangeOtherPlayerNames",
    Value = false,
    Callback = function(value)
        nameState.otherNamesEnabled = value
        invalidateNameReplacementCache()
        refreshAllNameElements()
    end
})
customTab:Divider({Title = "loc:section.skybox"})
customTab:Dropdown({
    Title = "loc:dropdown.choose_skybox",
    Flag = "SkyboxDropdown",
    Values = skyboxNames,
    SearchBarEnabled = true,
    Value = "Original",
    Callback = function(name)
        requestSkybox(name)
    end
})
customTab:Button({
    Title = "loc:button.restore_sky",
    Callback = function()
        restoreSkybox()
        notify({MessageKey = "notification.sky_restored", Type = "done"})
    end
})

customTab:Divider({Title = "loc:section.rtx"})
customTab:Dropdown({
    Title = "loc:dropdown.lighting_preset",
    Flag = "RTXPreset",
    Values = lightingOptions,
    Value = lightingOptions[1],
    Callback = function(name)
        name = optionValue(name, lightingOptions)
        applyRTX(name)
        notify({MessageKey = "notification.rtx_changed", Args = {name}, Type = "done"})
    end
})
customTab:Button({
    Title = "loc:button.restore_visuals",
    Callback = function()
        restoreSkybox()
        restoreRTX()
        notify({MessageKey = "notification.visuals_restored", Type = "done"})
    end
})

customTab:Divider({Title = "loc:section.environment"})
customTab:Slider({
    Title = "loc:slider.time_of_day",
    Flag = "VisualClockTime",
    Value = {
        Min = 0,
        Max = 24,
        Default = originalLightingState.ClockTime
    },
    Step = 0.25,
    Callback = function(value)
        Lighting.ClockTime = value
    end
})
customTab:Slider({
    Title = "loc:slider.brightness",
    Flag = "VisualBrightness",
    Value = {
        Min = 0,
        Max = 6,
        Default = originalLightingState.Brightness
    },
    Step = 0.1,
    Callback = function(value)
        Lighting.Brightness = value
    end
})
customTab:Slider({
    Title = "loc:slider.exposure",
    Flag = "VisualExposure",
    Value = {
        Min = -2,
        Max = 2,
        Default = originalLightingState.ExposureCompensation
    },
    Step = 0.05,
    Callback = function(value)
        Lighting.ExposureCompensation = value
    end
})
customTab:Slider({
    Title = "loc:slider.fog_distance",
    Flag = "VisualFogEnd",
    Value = {
        Min = 100,
        Max = 100000,
        Default = math.clamp(originalLightingState.FogEnd, 100, 100000)
    },
    Step = 100,
    Callback = function(value)
        Lighting.FogEnd = value
    end
})
customTab:Colorpicker({
    Title = "loc:color.ambient",
    Flag = "VisualAmbient",
    Color = originalLightingState.Ambient,
    Callback = function(color)
        Lighting.Ambient = color
    end
})

customTab:Divider({Title = "Extra"})
customTab:Divider({Title = "loc:section.kill_sound"})
customTab:Toggle({
    Title = "loc:toggle.kill_sound",
    Flag = "KillSoundEnabled",
    Value = false,
    Callback = function(value)
        dmvsKillSoundState.Enabled = value
    end
})
customTab:Dropdown({
    Title = "loc:dropdown.kill_sound",
    Flag = "KillSoundSelection",
    Values = dmvsKillSoundState.Options,
    Value = "Among Us",
    Callback = function(value)
        if type(value) == "table" then
            value = value.Value or value.Title
        end
        if type(value) == "string" and dmvsKillSoundState.Assets[value] then
            dmvsKillSoundState.Selected = value
            pcall(function()
                if notify then
                    notify({
                        Title = "Kill Sound",
                        Content = "Seleccionado: " .. tostring(value),
                        Duration = 2
                    })
                end
            end)
            pcall(function() if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end end)
        end
    end
})

-- Disparo / Recarga
local RecargaDisparoEnabled = false
local KillSoundVolumeFX = 1
do
    local SoundService = game:GetService("SoundService")
    local ShootSoundId = "680140087"
    local ReloadSoundId = "138084889"
    local ShootSoundPlayer = Instance.new("Sound")
    ShootSoundPlayer.Name = "FlexusShootFX"
    ShootSoundPlayer.Parent = SoundService
    local ReloadSoundPlayer = Instance.new("Sound")
    ReloadSoundPlayer.Name = "FlexusReloadFX"
    ReloadSoundPlayer.Parent = SoundService
    local shootToken = 0
    local SHOOT_MAX_DUR = 1.2

    local function PlayShootSound()
        if not RecargaDisparoEnabled then return end
        shootToken = shootToken + 1
        local my = shootToken
        ShootSoundPlayer:Stop()
        ShootSoundPlayer.SoundId = "rbxassetid://" .. ShootSoundId
        ShootSoundPlayer.Volume = KillSoundVolumeFX
        ShootSoundPlayer:Play()
        task.delay(SHOOT_MAX_DUR, function()
            if shootToken == my and ShootSoundPlayer.Playing then
                ShootSoundPlayer:Stop()
            end
        end)
    end

    local function PlayReloadSound()
        if not RecargaDisparoEnabled then return end
        ReloadSoundPlayer:Stop()
        ReloadSoundPlayer.SoundId = "rbxassetid://" .. ReloadSoundId
        ReloadSoundPlayer.Volume = KillSoundVolumeFX
        ReloadSoundPlayer:Play()
    end

    local FIRE_KW = { "fire", "shoot", "shot", "gun", "burst", "shotgun", "gunshot", "muzzle", "rifle", "pistol", "shooting", "firing" }
    local function isFireSound(s)
        if not s:IsA("Sound") then return false end
        local n = string.lower(s.Name)
        for _, kw in ipairs(FIRE_KW) do
            if string.find(n, kw, 1, true) then return true end
        end
        return false
    end

    local function estaRecargando(arma)
        if not arma or not arma:IsA("Tool") then return false end
        for _, name in ipairs({"Reloading", "IsReloading", "reloading", "isReloading", "Reload", "reload"}) do
            local v = arma:GetAttribute(name)
            if v == true or v == "true" then return true end
        end
        for _, child in ipairs(arma:GetChildren()) do
            if child:IsA("BoolValue") and child.Value == true then
                local n = string.lower(child.Name)
                if string.find(n, "reload") or string.find(n, "recarg") then return true end
            end
        end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
                local animId = track.Animation and track.Animation.AnimationId or ""
                if string.find(string.lower(animId), "reload") then return true end
            end
        end
        for _, s in ipairs(arma:GetDescendants()) do
            if s:IsA("Sound") and s.Playing then
                local n = string.lower(s.Name)
                if string.find(n, "reload") or string.find(n, "recarg") then return true end
            end
        end
        return false
    end

    local function HookFireSound(s)
        if not s:IsA("Sound") then return end
        if not isFireSound(s) then return end
        if s:GetAttribute("FlexusFireHooked") then return end
        s:SetAttribute("FlexusFireHooked", true)
        s.Played:Connect(function()
            if not RecargaDisparoEnabled then return end
            local char = player.Character
            if not char then return end
            local bp = player:FindFirstChildOfClass("Backpack")
            if s:IsDescendantOf(char) or (bp and s:IsDescendantOf(bp)) then
                PlayShootSound()
            end
        end)
    end

    local function HookShootOnTool(tool)
        if not tool or not tool:IsA("Tool") then return end
        for _, d in ipairs(tool:GetDescendants()) do
            HookFireSound(d)
        end
        if not tool:GetAttribute("FlexusToolHooked") then
            tool:SetAttribute("FlexusToolHooked", true)
            tool.DescendantAdded:Connect(HookFireSound)
        end
    end

    local function HookShootOnRoot(root)
        if not root then return end
        for _, child in ipairs(root:GetChildren()) do
            if child:IsA("Tool") then HookShootOnTool(child) end
        end
        root.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then HookShootOnTool(child) end
        end)
    end

    pcall(function()
        if player.Character then HookShootOnRoot(player.Character) end
        player.CharacterAdded:Connect(HookShootOnRoot)
        local bp = player:FindFirstChildOfClass("Backpack")
        if bp then
            for _, c in ipairs(bp:GetChildren()) do HookShootOnTool(c) end
            bp.ChildAdded:Connect(function(c) if c:IsA("Tool") then HookShootOnTool(c) end end)
        end
    end)

    task.spawn(function()
        local lastReloadState = false
        while task.wait(0.05) do
            if not RecargaDisparoEnabled then
                lastReloadState = false
            else
                local char = player.Character
                local arma = char and char:FindFirstChildOfClass("Tool")
                if not arma then
                    lastReloadState = false
                else
                    local recargando = estaRecargando(arma)
                    if recargando and not lastReloadState then
                        PlayReloadSound()
                    end
                    lastReloadState = recargando
                end
            end
        end
    end)
end

customTab:Toggle({
    Title = "Sonido Disparo + Recarga",
    Desc = "Efecto de audio al disparar y recargar.",
    Flag = "RecargaDisparo",
    Value = false,
    Callback = function(v) RecargaDisparoEnabled = v and true or false end
})
customTab:Slider({
    Title = "Volumen FX",
    Flag = "KillSoundVol",
    Value = {Min = 0, Max = 2, Default = 1},
    Step = 0.1,
    Callback = function(v) KillSoundVolumeFX = v end
})




animTab = Window:Tab({Title = "loc:tab.animations", Icon = "person-standing", ShowTabTitle = true, Border = true})
animTab:Divider({Title = "loc:section.full_animation_packs"})
selectedFullBundle = "None"
animTab:Dropdown({
    Title = "loc:dropdown.choose_pack",
    Flag = "AnimPack",
    Values = animList,
    SearchBarEnabled = true,
    Value = "None",
    Callback = function(v) selectedFullBundle = v; pcall(function() if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end end) end
})
animTab:Button({
    Title = "loc:button.apply_full_pack",
    Callback = function()
        if selectedFullBundle == "None" then return end
        task.spawn(function()
            currentActiveAnim = animationData[selectedFullBundle]
            applyCustomAnims(currentActiveAnim)
        end)
    end
})
animTab:Button({
    Title = "loc:button.restore_default",
    Callback = function()
        task.spawn(function()
            local defaultAnims = myOriginalAnims or {
                Idle = 507766666, Idle2 = 507766951, Walk = 507777826, Run = 507767714,
                Jump = 507765000, Climb = 507765644, Fall = 507767968, Swim = 507784897, SwimIdle = 507785072
            }
            currentActiveAnim = nil
            applyCustomAnims(defaultAnims)
        end)
    end
})
animTab:Divider({Title = "loc:section.animation_mixer"})
animTab:Dropdown({
    Title = "loc:dropdown.idle",
    Flag = "MixIdle",
    Values = animList,
    SearchBarEnabled = true,
    Value = "None",
    Callback = function(v) mixParts.Idle = v if autoMixApplyEnabled then applySelectedMix() end pcall(function() if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end end) end
})
animTab:Dropdown({
    Title = "loc:dropdown.walk",
    Flag = "MixWalk",
    Values = animList,
    SearchBarEnabled = true,
    Value = "None",
    Callback = function(v) mixParts.Walk = v if autoMixApplyEnabled then applySelectedMix() end pcall(function() if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end end) end
})
animTab:Dropdown({
    Title = "loc:dropdown.run",
    Flag = "MixRun",
    Values = animList,
    SearchBarEnabled = true,
    Value = "None",
    Callback = function(v) mixParts.Run = v if autoMixApplyEnabled then applySelectedMix() end pcall(function() if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end end) end
})
animTab:Dropdown({
    Title = "loc:dropdown.jump",
    Flag = "MixJump",
    Values = animList,
    SearchBarEnabled = true,
    Value = "None",
    Callback = function(v) mixParts.Jump = v if autoMixApplyEnabled then applySelectedMix() end pcall(function() if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end end) end
})
animTab:Dropdown({
    Title = "loc:dropdown.fall",
    Flag = "MixFall",
    Values = animList,
    SearchBarEnabled = true,
    Value = "None",
    Callback = function(v) mixParts.Fall = v if autoMixApplyEnabled then applySelectedMix() end pcall(function() if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end end) end
})
animTab:Dropdown({
    Title = "loc:dropdown.climb",
    Flag = "MixClimb",
    Values = animList,
    SearchBarEnabled = true,
    Value = "None",
    Callback = function(v) mixParts.Climb = v if autoMixApplyEnabled then applySelectedMix() end pcall(function() if _G.VXS_ScheduleSave then _G.VXS_ScheduleSave() end end) end
})
animTab:Button({
    Title = "loc:button.mix_apply",
    Callback = function()
        applySelectedMix()
    end
})
animTab:Toggle({
    Title = "loc:toggle.auto_mix_apply",
    Flag = "AutoMixApply",
    Value = false,
    Callback = function(value)
        autoMixApplyEnabled = value
        if value then
            applySelectedMix()
        end
    end
})

syncLoadedControlEffects()
if autoMixApplyEnabled then
    applySelectedMix()
end


-- ==========================================
-- VXS AUTOSAVE / AUTOLOAD
-- ==========================================
local VXS_CONFIG_FOLDER = "FlexusHub_DMVS"
local VXS_CONFIG_FILE = VXS_CONFIG_FOLDER .. "/autosave.json"
local vxsSaveBusy = false
local vxsSaveQueued = false
local vxsConfigLoaded = false
local vxsIsLoadingConfig = false

local function vxsEnsureFolder()
    if isfolder and not isfolder(VXS_CONFIG_FOLDER) then
        pcall(function() makefolder(VXS_CONFIG_FOLDER) end)
    end
end

local function vxsCollectState()
    local bubblePos = {}
    pcall(function()
        local bbs = _G.VXS_Bubbles
        if type(bbs) == "table" then
            for key, btn in pairs(bbs) do
                if btn and btn.Position then
                    bubblePos[key] = {
                        XS = btn.Position.X.Scale,
                        XO = btn.Position.X.Offset,
                        YS = btn.Position.Y.Scale,
                        YO = btn.Position.Y.Offset,
                        Visible = btn.Visible and true or false,
                    }
                end
            end
        end
    end)
    local bv = _G.VXS_BubbleVisibility or {}
    return {
        version = 2,
        toggles = {
            camlockEnabled = camlockEnabled,
            camlockOnlyGun = camlockOnlyGun,
            camlockFOVVisible = camlockFOVVisible,
            silentAimManualEnabled = silentAimManualEnabled,
            silentAimFOVVisible = silentAimFOVVisible,
            autoShootEnabled = autoShootEnabled,
            autoShootCuchilloEnabled = autoShootCuchilloEnabled,
            hitboxEnabled = hitboxEnabled,
            macroActive = macroActive,
            triggerEnabled = dmvsAutoMacroState and dmvsAutoMacroState.Enabled or false,
            espEnabled = espEnabled,
            killSound = dmvsKillSoundState and dmvsKillSoundState.Enabled or false,
            deadZoneVisible = deadZoneFrame and deadZoneFrame.Visible or false,
            bubbleDrag = _G.VXS_BubbleDragState and true or false,
            bubbleShowSilent = bv.silent and true or false,
            bubbleShowAuto = bv.auto and true or false,
            bubbleShowMacro = bv.macro and true or false,
            bubbleShowTrigger = bv.trigger and true or false,
            bubbleShowHitbox = bv.hitbox and true or false,
        },
        values = {
            camlockTargetPart = camlockTargetPart,
            camlockMode = camlockMode,
            camlockSmoothness = camlockSmoothness,
            camlockFOVRadius = camlockFOVRadius,
            silentAimTargetPart = silentAimTargetPart,
            silentAimMode = silentAimMode,
            silentAimFOVRadius = silentAimFOVRadius,
            autoShootTargetPart = autoShootTargetPart,
            autoShootFOVRadius = autoShootFOVRadius,
            hitboxSizeValue = hitboxSizeValue,
            hitboxTransparency = hitboxTransparency,
            triggerRange = dmvsAutoMacroState and dmvsAutoMacroState.Range or 250,
            killSoundSelected = dmvsKillSoundState and dmvsKillSoundState.Selected or "Among Us",
            deadZoneSize = deadZoneFrame and deadZoneFrame.Size.X.Offset or 150,
            selectedFullBundle = selectedFullBundle or "None",
            mixIdle = mixParts and mixParts.Idle or "None",
            mixWalk = mixParts and mixParts.Walk or "None",
            mixRun = mixParts and mixParts.Run or "None",
            mixJump = mixParts and mixParts.Jump or "None",
            mixFall = mixParts and mixParts.Fall or "None",
            mixClimb = mixParts and mixParts.Climb or "None",
            autoMixApply = autoMixApplyEnabled and true or false,
        },
        colors = {
            camlockFOV = camlockFOVColor and {R = camlockFOVColor.R, G = camlockFOVColor.G, B = camlockFOVColor.B} or nil,
            silentFOV = silentAimFOVColor and {R = silentAimFOVColor.R, G = silentAimFOVColor.G, B = silentAimFOVColor.B} or nil,
            autoFOV = autoShootFOVColor and {R = autoShootFOVColor.R, G = autoShootFOVColor.G, B = autoShootFOVColor.B} or nil,
            espBox = ESP_CONFIG and ESP_CONFIG.BoxColor and {R = ESP_CONFIG.BoxColor.R, G = ESP_CONFIG.BoxColor.G, B = ESP_CONFIG.BoxColor.B} or nil,
        },
        bubbles = bubblePos,
    }
end

-- permitir que bubbles tab actualice flags de show en el collect
_G.VXS_BubbleVisibility = _G.VXS_BubbleVisibility or {
    silent = false, auto = false, macro = false, trigger = false, hitbox = false, killall = false
}

local function vxsCollectStateFull()
    local st = vxsCollectState()
    local bv = _G.VXS_BubbleVisibility
    if bv then
        st.toggles.bubbleShowSilent = bv.silent and true or false
        st.toggles.bubbleShowAuto = bv.auto and true or false
        st.toggles.bubbleShowMacro = bv.macro and true or false
        st.toggles.bubbleShowTrigger = bv.trigger and true or false
        st.toggles.bubbleShowHitbox = bv.hitbox and true or false
    end
    st.toggles.bubbleDrag = _G.VXS_BubbleDragState and true or false
    return st
end

local function vxsSaveConfig()
    if vxsSaveBusy or not writefile or not HttpService then return end
    vxsSaveBusy = true
    pcall(function()
        vxsEnsureFolder()
        local data = vxsCollectStateFull()
        writefile(VXS_CONFIG_FILE, HttpService:JSONEncode(data))
    end)
    vxsSaveBusy = false
    if vxsSaveQueued then
        vxsSaveQueued = false
        task.defer(vxsSaveConfig)
    end
end

-- ScheduleSave se define junto al ConfigManager abajo



-- Forzar que el toggle de WindUI se vea ON/OFF visualmente
local function vxsForceToggleVisual(el, value)
    if type(el) ~= "table" then return false end
    value = value and true or false
    local ok = false
    pcall(function()
        if el.Set then el:Set(value); ok = true end
    end)
    if not ok then
        pcall(function()
            if el.SetValue then el:SetValue(value); ok = true end
        end)
    end
    if not ok then
        pcall(function()
            if el.SetState then el:SetState(value); ok = true end
        end)
    end
    -- props internas comunes WindUI
    pcall(function()
        if el.Value ~= nil then el.Value = value end
        if el.State ~= nil then el.State = value end
        if el.Toggled ~= nil then el.Toggled = value end
        if el.Enabled ~= nil and type(el.Enabled) == "boolean" then end
    end)
    -- UI objects
    pcall(function()
        if el.Button and el.Button.BackgroundColor3 then
            -- no color hack; prefer API
        end
        if type(el.Update) == "function" then el:Update(value) end
        if type(el.Refresh) == "function" then el:Refresh() end
        if type(el.Render) == "function" then el:Render() end
    end)
    return ok
end

local function vxsSyncAllToggleVisuals()
    -- Version LIGERA: no recorre todos los flags ni dispara callbacks en masa (congela)
    if vxsIsLoadingConfig then
        -- solo bubbles durante load
        pcall(function()
            if _G.VXS_UpdateBubble then
                _G.VXS_UpdateBubble("silent", silentAimManualEnabled)
                _G.VXS_UpdateBubble("auto", autoShootEnabled)
                _G.VXS_UpdateBubble("macro", macroActive)
                _G.VXS_UpdateBubble("trigger", dmvsAutoMacroState and dmvsAutoMacroState.Enabled)
                _G.VXS_UpdateBubble("hitbox", hitboxEnabled)
            end
        end)
        return
    end
    -- Visual combate (pocos elementos)
    local refs = _G.VXS_CombatToggles or {}
    local map = {
        silent = silentAimManualEnabled,
        auto = autoShootEnabled,
        macro = macroActive,
        trigger = dmvsAutoMacroState and dmvsAutoMacroState.Enabled,
        hitbox = hitboxEnabled,
    }
    for k, val in pairs(map) do
        local el = refs[k]
        if type(el) == "table" then
            pcall(function()
                if el.Set then el:Set(val)
                elseif el.SetValue then el:SetValue(val)
                end
            end)
        end
    end
    pcall(function()
        if _G.VXS_UpdateBubble then
            _G.VXS_UpdateBubble("silent", silentAimManualEnabled)
            _G.VXS_UpdateBubble("auto", autoShootEnabled)
            _G.VXS_UpdateBubble("macro", macroActive)
            _G.VXS_UpdateBubble("trigger", dmvsAutoMacroState and dmvsAutoMacroState.Enabled)
            _G.VXS_UpdateBubble("hitbox", hitboxEnabled)
        end
    end)
end

local function vxsApplyState(data)
    if type(data) ~= "table" then return end
    local tg = data.toggles or {}
    local vl = data.values or {}
    local col = data.colors or {}

    if tg.camlockEnabled ~= nil then camlockEnabled = tg.camlockEnabled end
    if tg.camlockOnlyGun ~= nil then camlockOnlyGun = tg.camlockOnlyGun end
    if tg.camlockFOVVisible ~= nil then camlockFOVVisible = tg.camlockFOVVisible end
    if tg.silentAimManualEnabled ~= nil then silentAimManualEnabled = tg.silentAimManualEnabled end
    if tg.silentAimFOVVisible ~= nil then silentAimFOVVisible = tg.silentAimFOVVisible end
    if tg.autoShootEnabled ~= nil then autoShootEnabled = tg.autoShootEnabled end
    if tg.autoShootCuchilloEnabled ~= nil then autoShootCuchilloEnabled = tg.autoShootCuchilloEnabled end
    if tg.hitboxEnabled ~= nil then
        hitboxEnabled = tg.hitboxEnabled
        if not hitboxEnabled then pcall(clearAllHitboxes) end
    end
    if tg.macroActive ~= nil then macroActive = tg.macroActive end
    if tg.triggerEnabled ~= nil and dmvsAutoMacroState then
        dmvsAutoMacroState.Enabled = tg.triggerEnabled
        dmvsAutoMacroState.TeamCheck = true
        dmvsAutoMacroState.WallCheck = true
    end
    if tg.espEnabled ~= nil then espEnabled = tg.espEnabled end
    if tg.killSound ~= nil and dmvsKillSoundState then dmvsKillSoundState.Enabled = tg.killSound end
    if tg.deadZoneVisible ~= nil and deadZoneFrame then deadZoneFrame.Visible = tg.deadZoneVisible end

    if vl.camlockTargetPart then camlockTargetPart = vl.camlockTargetPart end
    if vl.camlockMode then camlockMode = vl.camlockMode end
    if vl.camlockSmoothness then camlockSmoothness = vl.camlockSmoothness end
    if vl.camlockFOVRadius then camlockFOVRadius = vl.camlockFOVRadius end
    if vl.silentAimTargetPart then silentAimTargetPart = vl.silentAimTargetPart end
    if vl.silentAimMode then silentAimMode = vl.silentAimMode end
    if vl.silentAimFOVRadius then silentAimFOVRadius = vl.silentAimFOVRadius end
    if vl.autoShootTargetPart then autoShootTargetPart = vl.autoShootTargetPart end
    if vl.hitboxSizeValue then
        hitboxSizeValue = vl.hitboxSizeValue
        CustomHitboxSize = Vector3.new(hitboxSizeValue, hitboxSizeValue, hitboxSizeValue)
    end
    if vl.hitboxTransparency then hitboxTransparency = vl.hitboxTransparency end
    if vl.triggerRange and dmvsAutoMacroState then dmvsAutoMacroState.Range = vl.triggerRange end
    if vl.killSoundSelected and dmvsKillSoundState then dmvsKillSoundState.Selected = vl.killSoundSelected end
    if vl.deadZoneSize and deadZoneFrame then
        deadZoneFrame.Size = UDim2.new(0, vl.deadZoneSize, 0, vl.deadZoneSize)
    end
    if vl.selectedFullBundle then selectedFullBundle = vl.selectedFullBundle end
    if mixParts then
        if vl.mixIdle then mixParts.Idle = vl.mixIdle end
        if vl.mixWalk then mixParts.Walk = vl.mixWalk end
        if vl.mixRun then mixParts.Run = vl.mixRun end
        if vl.mixJump then mixParts.Jump = vl.mixJump end
        if vl.mixFall then mixParts.Fall = vl.mixFall end
        if vl.mixClimb then mixParts.Climb = vl.mixClimb end
    end
    if vl.autoMixApply ~= nil then autoMixApplyEnabled = vl.autoMixApply and true or false end

    if col.camlockFOV then
        camlockFOVColor = Color3.new(col.camlockFOV.R or 1, col.camlockFOV.G or 1, col.camlockFOV.B or 1)
    end
    if col.silentFOV then
        silentAimFOVColor = Color3.new(col.silentFOV.R or 1, col.silentFOV.G or 1, col.silentFOV.B or 1)
    end
    if col.espBox and ESP_CONFIG then
        ESP_CONFIG.BoxColor = Color3.new(col.espBox.R or 1, col.espBox.G or 1, col.espBox.B or 1)
    end

    -- Bubbles visibility + active states + posiciones
    if type(data.bubbles) == "table" then
        _G.VXS_SavedBubblePos = data.bubbles
        pcall(function()
            local bbs = _G.VXS_Bubbles
            if type(bbs) == "table" then
                for key, pos in pairs(data.bubbles) do
                    local btn = bbs[key]
                    if btn and type(pos) == "table" then
                        btn.Position = UDim2.new(pos.XS or 1, pos.XO or -54, pos.YS or 0.36, pos.YO or 0)
                        if pos.Visible ~= nil then btn.Visible = pos.Visible and true or false end
                    end
                end
            end
        end)
    end
    local bv = _G.VXS_BubbleVisibility
    if bv then
        bv.silent = tg.bubbleShowSilent and true or false
        bv.auto = tg.bubbleShowAuto and true or false
        bv.macro = tg.bubbleShowMacro and true or false
        bv.trigger = tg.bubbleShowTrigger and true or false
        bv.hitbox = tg.bubbleShowHitbox and true or false
    end
    if _G.VXS_BubbleShow then
        pcall(function()
            _G.VXS_BubbleShow("silent", tg.bubbleShowSilent)
            _G.VXS_BubbleShow("auto", tg.bubbleShowAuto)
            _G.VXS_BubbleShow("macro", tg.bubbleShowMacro)
            _G.VXS_BubbleShow("trigger", tg.bubbleShowTrigger)
            _G.VXS_BubbleShow("hitbox", tg.bubbleShowHitbox)
        end)
    end
    if _G.VXS_UpdateBubble then
        pcall(function()
            _G.VXS_UpdateBubble("silent", silentAimManualEnabled)
            _G.VXS_UpdateBubble("auto", autoShootEnabled)
            _G.VXS_UpdateBubble("macro", macroActive)
            _G.VXS_UpdateBubble("trigger", dmvsAutoMacroState and dmvsAutoMacroState.Enabled)
            _G.VXS_UpdateBubble("hitbox", hitboxEnabled)
        end)
    end
    -- Solo bubbles (sin Set masivo de UI)
    pcall(function()
        if _G.VXS_UpdateBubble then
            _G.VXS_UpdateBubble("silent", silentAimManualEnabled)
            _G.VXS_UpdateBubble("auto", autoShootEnabled)
            _G.VXS_UpdateBubble("macro", macroActive)
            _G.VXS_UpdateBubble("trigger", dmvsAutoMacroState and dmvsAutoMacroState.Enabled)
            _G.VXS_UpdateBubble("hitbox", hitboxEnabled)
        end
    end)
    if tg.bubbleDrag and _G.VXS_BubbleDragMode then
        pcall(function() _G.VXS_BubbleDragMode(true) end)
        _G.VXS_BubbleDragState = true
    end

    -- Kill all siempre off
    if dmvsKillAllState then dmvsKillAllState.Enabled = false end
end

local function vxsLoadConfig()
    -- Solo bubbles / pos. Los toggles los carga ConfigManager (WindUI).
    if not (isfile and readfile and HttpService) then return end
    pcall(function()
        vxsEnsureFolder()
        if isfile(VXS_CONFIG_FILE) then
            local raw = readfile(VXS_CONFIG_FILE)
            local data = HttpService:JSONDecode(raw)
            if type(data) == "table" and type(data.bubbles) == "table" then
                _G.VXS_SavedBubblePos = data.bubbles
            end
        end
    end)
end

-- ==========================================
-- SIN AUTO-SAVE (guardado manual en tab Guardado)
-- ==========================================
_G.VXS_ScheduleSave = function() end -- desactivado
vxsConfigLoaded = true
vxsIsLoadingConfig = false


-- ===== MUSIC (Extra) =====
;(function()
    local musicTab = Window:Tab({Title = "Music", Icon = "music", ShowTabTitle = true, Border = true})
    local SoundService = game:GetService("SoundService")
    local MusicPlayer = Instance.new("Sound")
    MusicPlayer.Name = "FlexusHub_MusicPlayer"
    MusicPlayer.Looped = false
    MusicPlayer.Volume = 0.5
    MusicPlayer.SoundId = ""
    MusicPlayer.Parent = SoundService

    local SongList = {
        { Name = "Cancion 1", Id = "84944985070181" },
        { Name = "Cancion 2", Id = "87570666848900" },
        { Name = "Cancion 3", Id = "82746224492420" },
        { Name = "Cancion 4", Id = "71393805905055" },
        { Name = "Cancion 5", Id = "75688616622595" },
        { Name = "Cancion 6", Id = "135609653444873" },
        { Name = "Cancion 7", Id = "93699644879957" },
        { Name = "Cancion 8", Id = "110398343528156" },
        { Name = "Cancion 9", Id = "138863509657081" },
        { Name = "Cancion 10", Id = "115440201770223" },
        { Name = "Cancion 11", Id = "128048502331483" },
        { Name = "Cancion 12", Id = "135321902579514" },
        { Name = "Cancion 13", Id = "131465489873214" },
        { Name = "Cancion 14", Id = "6537242620" },
    }

    local CurrentIndex = 1
    local ShuffleOn = false
    local musicUserStarted = false -- solo suena si el usuario dio Play/Siguiente
    local NowPlayingParagraph

    local function OptionLabel(song)
        return song.Name .. " (" .. song.Id .. ")"
    end

    local function UpdateNowPlaying()
        local song = SongList[CurrentIndex]
        if not NowPlayingParagraph then return end
        if not song then return end
        if not musicUserStarted or MusicPlayer.SoundId == "" then
            pcall(function()
                if NowPlayingParagraph.SetTitle then NowPlayingParagraph:SetTitle("Sin cancion seleccionada") end
                if NowPlayingParagraph.SetDesc then NowPlayingParagraph:SetDesc("Presiona Play o Siguiente para escuchar") end
            end)
            return
        end
        local estado = MusicPlayer.Playing and "Reproduciendo" or "Pausado"
        pcall(function()
            if NowPlayingParagraph.SetTitle then NowPlayingParagraph:SetTitle(song.Name) end
            if NowPlayingParagraph.SetDesc then
                NowPlayingParagraph:SetDesc(("%s • ID: %s • %s"):format(song.Name, song.Id, estado))
            end
        end)
    end

    -- Solo carga ID, NO reproduce
    local function SelectSong(index)
        if not SongList[index] then return end
        CurrentIndex = index
        UpdateNowPlaying()
    end

    -- Reproduce (solo cuando el usuario pide Play/Siguiente/Anterior)
    local function LoadAndPlay(index)
        if not SongList[index] then return end
        musicUserStarted = true
        CurrentIndex = index
        pcall(function() MusicPlayer:Stop() end)
        MusicPlayer.SoundId = "rbxassetid://" .. SongList[index].Id
        pcall(function() MusicPlayer:Play() end)
        UpdateNowPlaying()
    end

    local function PlaySong()
        musicUserStarted = true
        if MusicPlayer.SoundId == "" or not string.find(MusicPlayer.SoundId, SongList[CurrentIndex].Id, 1, true) then
            LoadAndPlay(CurrentIndex)
        elseif not MusicPlayer.Playing then
            pcall(function() MusicPlayer:Resume() end)
            if not MusicPlayer.Playing then
                pcall(function() MusicPlayer:Play() end)
            end
        end
        UpdateNowPlaying()
    end

    local function PauseSong()
        if MusicPlayer.Playing then pcall(function() MusicPlayer:Pause() end) end
        UpdateNowPlaying()
    end

    local function StopSong()
        pcall(function() MusicPlayer:Stop() end)
        MusicPlayer.SoundId = ""
        musicUserStarted = false
        UpdateNowPlaying()
    end

    local function NextSong()
        local nextIndex
        if ShuffleOn then
            nextIndex = math.random(1, #SongList)
        else
            nextIndex = CurrentIndex + 1
            if nextIndex > #SongList then nextIndex = 1 end
        end
        LoadAndPlay(nextIndex)
    end

    local function PrevSong()
        local prevIndex
        if ShuffleOn then
            prevIndex = math.random(1, #SongList)
        else
            prevIndex = CurrentIndex - 1
            if prevIndex < 1 then prevIndex = #SongList end
        end
        LoadAndPlay(prevIndex)
    end

    -- Solo avanza si el usuario ya puso play alguna vez
    MusicPlayer.Ended:Connect(function()
        if musicUserStarted and not MusicPlayer.Looped then
            NextSong()
        end
    end)

    musicTab:Section({ Title = "Ahora suena", Icon = "music" })
    NowPlayingParagraph = musicTab:Paragraph({
        Title = "Sin cancion seleccionada",
        Desc = "Presiona Play o Siguiente para escuchar",
        Icon = "music",
    })
    UpdateNowPlaying()

    musicTab:Section({ Title = "Controles", Icon = "settings" })
    musicTab:Button({
        Title = "Anterior",
        Desc = "Cancion previa (reproduce)",
        Callback = function() PrevSong() end,
    })
    musicTab:Button({
        Title = "Siguiente",
        Desc = "Siguiente cancion (reproduce)",
        Callback = function() NextSong() end,
    })
    musicTab:Button({
        Title = "Play",
        Desc = "Reproducir o reanudar",
        Callback = function() PlaySong() end,
    })
    musicTab:Button({
        Title = "Pausa",
        Desc = "Pausar sin perder progreso",
        Callback = function() PauseSong() end,
    })
    musicTab:Button({
        Title = "Stop",
        Desc = "Detener completamente",
        Callback = function() StopSong() end,
    })

    musicTab:Section({ Title = "Seleccionar musica", Icon = "list" })
    local SongDropdown
    SongDropdown = musicTab:Dropdown({
        Title = "Cancion",
        Desc = "Elige cancion (NO reproduce hasta Play/Siguiente)",
        Values = (function()
            local options = {}
            for _, song in ipairs(SongList) do
                table.insert(options, OptionLabel(song))
            end
            return options
        end)(),
        Value = OptionLabel(SongList[1]),
        Callback = function(selected)
            -- Solo selecciona, no reproduce al abrir el script ni al elegir
            for i, song in ipairs(SongList) do
                if selected == OptionLabel(song) then
                    SelectSong(i)
                    break
                end
            end
        end,
    })

    musicTab:Section({ Title = "Preferencias", Icon = "settings" })
    musicTab:Toggle({
        Title = "Aleatorio",
        Desc = "Elige cancion al azar al avanzar",
        Value = false,
        Callback = function(state) ShuffleOn = state end,
    })
    musicTab:Toggle({
        Title = "Repetir",
        Desc = "Repite la misma cancion al terminar",
        Value = false,
        Callback = function(state) MusicPlayer.Looped = state end,
    })
    musicTab:Slider({
        Title = "Volumen",
        Desc = "Volumen de reproduccion",
        Value = { Min = 0, Max = 100, Default = 50 },
        Step = 1,
        Callback = function(value) MusicPlayer.Volume = value / 100 end,
    })

    musicTab:Section({ Title = "Agregar por ID", Icon = "plus" })
    local NewName, NewId = "", ""
    musicTab:Input({
        Title = "Nombre",
        Placeholder = "Ej: Mi cancion",
        Callback = function(value) NewName = value end,
    })
    musicTab:Input({
        Title = "ID Roblox",
        Placeholder = "Ej: 1234567890",
        Callback = function(value) NewId = tostring(value or ""):gsub("%D", "") end,
    })

    local function RefreshDropdownOptions()
        local options = {}
        for _, song in ipairs(SongList) do
            table.insert(options, OptionLabel(song))
        end
        pcall(function()
            if SongDropdown and SongDropdown.Refresh then
                SongDropdown:Refresh(options)
            end
        end)
    end

    musicTab:Button({
        Title = "Agregar cancion",
        Desc = "Guarda nombre e ID en la lista",
        Callback = function()
            if NewName ~= "" and NewId ~= "" then
                for _, song in ipairs(SongList) do
                    if song.Id == NewId then return end
                end
                table.insert(SongList, { Name = NewName, Id = NewId })
                RefreshDropdownOptions()
                pcall(function()
                    if notify then
                        notify({ Title = "Music", Content = "Agregada: " .. NewName, Duration = 2 })
                    end
                end)
            end
        end,
    })
end)()

-- ===== GUARDADO MANUAL =====
;(function()
    local saveTab = Window:Tab({Title = "Guardado", Icon = "save", ShowTabTitle = true, Border = true})
    local configFolder = "FlexusHub_DMVS_Manual"
    pcall(function()
        if isfolder and not isfolder(configFolder) then makefolder(configFolder) end
    end)
    local available = {"None"}
    local selectedConfig = "None"
    local customName = ""
    local drop = saveTab:Dropdown({
        Title = "Configuracion",
        Values = available,
        Value = "None",
        Callback = function(v) selectedConfig = v end
    })
    local function refresh()
        local list = {}
        pcall(function()
            if listfiles then
                for _, f in ipairs(listfiles(configFolder)) do
                    local name = tostring(f):match("([^/\\]+)%.json$")
                    if name then table.insert(list, name) end
                end
            end
        end)
        if #list == 0 then list = {"None"} end
        available = list
        pcall(function() if drop.Refresh then drop:Refresh(list) end end)
    end
    saveTab:Button({Title = "Refrescar lista", Callback = refresh})
    saveTab:Input({Title = "Nombre al guardar", Callback = function(v) customName = v end})
    saveTab:Button({
        Title = "Guardar configuracion",
        Callback = function()
            local name = (customName ~= "" and customName) or selectedConfig
            if not name or name == "" or name == "None" then
                pcall(function() if notify then notify({Title="Guardado", Content="Escribe un nombre"}) end end)
                return
            end
            name = name:gsub("[^%w%s%-_]", "")
            local data = {
                Toggles = {
                    SilentAim = silentAimManualEnabled,
                    SilentFOV = silentAimFovEnabled,
                    AutoShoot = autoShootEnabled,
                    AutoShootAgr = autoShootAgresivoEnabled,
                    Macro = macroActive,
                    Trigger = dmvsAutoMacroState and dmvsAutoMacroState.Enabled,
                    Hitbox = hitboxEnabled,
                    ESP = espEnabled,
                    KillAll = KillAllEnabled,
                    KillSound = dmvsKillSoundState and dmvsKillSoundState.Enabled,
                },
                Values = {
                    SilentFOVRadius = silentAimFOVRadius,
                    HitboxSize = hitboxSizeValue,
                    KillSound = dmvsKillSoundState and dmvsKillSoundState.Selected,
                }
            }
            pcall(function()
                if writefile and HttpService then
                    writefile(configFolder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
                    if notify then notify({Title="Guardado", Content="OK: "..name}) end
                    refresh()
                end
            end)
        end
    })
    saveTab:Button({
        Title = "Cargar configuracion",
        Callback = function()
            if not selectedConfig or selectedConfig == "None" then
                pcall(function() if notify then notify({Title="Guardado", Content="Selecciona una config"}) end end)
                return
            end
            local path = configFolder .. "/" .. selectedConfig .. ".json"
            pcall(function()
                if not (isfile and isfile(path)) then return end
                local data = HttpService:JSONDecode(readfile(path))
                local tg = data.Toggles or {}
                if tg.SilentAim ~= nil then silentAimManualEnabled = tg.SilentAim end
                if tg.SilentFOV ~= nil then silentAimFovEnabled = tg.SilentFOV end
                if tg.AutoShoot ~= nil then autoShootEnabled = tg.AutoShoot end
                if tg.AutoShootAgr ~= nil then autoShootAgresivoEnabled = tg.AutoShootAgr end
                if tg.Macro ~= nil then macroActive = tg.Macro end
                if tg.Trigger ~= nil and dmvsAutoMacroState then dmvsAutoMacroState.Enabled = tg.Trigger end
                if tg.Hitbox ~= nil then hitboxEnabled = tg.Hitbox end
                if tg.ESP ~= nil then espEnabled = tg.ESP end
                if tg.KillAll ~= nil then
                    KillAllEnabled = tg.KillAll
                    if KillAllEnabled and KillAllInstance then KillAllInstance:Start()
                    elseif KillAllInstance then KillAllInstance:Stop() end
                end
                if tg.KillSound ~= nil and dmvsKillSoundState then dmvsKillSoundState.Enabled = tg.KillSound end
                local vl = data.Values or {}
                if vl.SilentFOVRadius then silentAimFOVRadius = vl.SilentFOVRadius end
                if vl.HitboxSize then hitboxSizeValue = vl.HitboxSize end
                if vl.KillSound and dmvsKillSoundState then dmvsKillSoundState.Selected = vl.KillSound end
                -- sync bubbles + toggle refs
                pcall(function()
                    if _G.VXS_UpdateBubble then
                        _G.VXS_UpdateBubble("silent", silentAimManualEnabled)
                        _G.VXS_UpdateBubble("auto", autoShootEnabled)
                        _G.VXS_UpdateBubble("macro", macroActive)
                        _G.VXS_UpdateBubble("trigger", dmvsAutoMacroState and dmvsAutoMacroState.Enabled)
                        _G.VXS_UpdateBubble("hitbox", hitboxEnabled)
                    end
                end)
                pcall(function()
                    local refs = _G.VXS_CombatToggles or {}
                    local map = {silent=silentAimManualEnabled, auto=autoShootEnabled, macro=macroActive,
                        trigger=dmvsAutoMacroState and dmvsAutoMacroState.Enabled, hitbox=hitboxEnabled}
                    for k,val in pairs(map) do
                        local el = refs[k]
                        if el and el.Set then pcall(function() el:Set(val) end) end
                    end
                end)
                if notify then notify({Title="Guardado", Content="Cargado: "..selectedConfig}) end
            end)
        end
    })
    task.defer(refresh)
end)()


Window:OnDestroy(function()
    pcall(function()
        if Window and Window.CurrentConfig and Window.CurrentConfig.Save then
            Window.CurrentConfig:Save()
        end
    end)
    pcall(vxsSaveConfig)

    dmvsDestroyed = true
    -- Apagar features visuales / combate
    pcall(function() silentAimEnabled = false end)
    pcall(function() autoShootEnabled = false end)
    pcall(function() camlockEnabled = false end)
    pcall(function() triggerbotEnabled = false end)
    pcall(function() hitboxEnabled = false end)
    pcall(function() silentAimFOVVisible = false end)
    pcall(function() autoShootFOVVisible = false end)
    pcall(function() camlockFOVVisible = false end)
    -- Bubbles fuera
    pcall(function()
        if _G.VXS_BubbleGui then _G.VXS_BubbleGui:Destroy() end
        _G.VXS_BubbleGui = nil
        _G.VXS_Bubbles = nil
        _G.VXS_UpdateBubble = nil
        _G.VXS_BubbleShow = nil
        _G.VXS_BubbleDragMode = nil
    end)
    -- Desconectar FOV render
    pcall(function()
        if fovRenderConnection then pcall(function() fovRenderConnection:Disconnect() end) end
    end)

    dmvsAutoMacroState.Enabled = false
    dmvsAutoMacroState.CurrentTarget = nil
    if dmvsAutoMacroState.ManagedGun then
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        dmvsAutoMacroCleanupGun(dmvsAutoMacroState.ManagedGun, character, humanoid)
    end
    if dmvsKillAllState then dmvsKillAllState.Enabled = false end
    dmvsKillSoundState.Enabled = false
    pcall(function()
        if dmvsKillSoundState.PlayerAddedConnection then
            dmvsKillSoundState.PlayerAddedConnection:Disconnect()
        end
    end)
    pcall(function()
        if dmvsKillSoundState.PlayerRemovingConnection then
            dmvsKillSoundState.PlayerRemovingConnection:Disconnect()
        end
    end)
    for targetPlayer in pairs(dmvsKillSoundState.PlayerConnections) do
        dmvsUnregisterKillSoundPlayer(targetPlayer)
    end
    nameState.myUsernameEnabled = false
    nameState.otherNamesEnabled = false
    refreshAllNameElements()
    restoreSkybox()
    restoreRTX()
    -- FOV Drawing + GUI: limpiar siempre
    pcall(function() if SilentFOVCircle then SilentFOVCircle.Visible = false; SilentFOVCircle:Remove() end end)
    pcall(function() if AutoFOVCircle then AutoFOVCircle.Visible = false; AutoFOVCircle:Remove() end end)
    pcall(function() if CamlockFOVCircle then CamlockFOVCircle.Visible = false; CamlockFOVCircle:Remove() end end)
    pcall(function()
        if guiCamlockFOV and guiCamlockFOV.Container then guiCamlockFOV.Container:Destroy() end
        if guiSilentFOV and guiSilentFOV.Container then guiSilentFOV.Container:Destroy() end
        if guiAutoFOV and guiAutoFOV.Container then guiAutoFOV.Container:Destroy() end
    end)
    pcall(function() if SilentFOVGuiNew then SilentFOVGuiNew:Destroy() end end)
    pcall(function() if AutoFOVGuiNew then AutoFOVGuiNew:Destroy() end end)
    pcall(function() if CamlockFOVGuiNew then CamlockFOVGuiNew:Destroy() end end)
    pcall(function() if SilentFOVFrameNew then SilentFOVFrameNew:Destroy() end end)
    pcall(function() if AutoFOVFrameNew then AutoFOVFrameNew:Destroy() end end)
    pcall(function() if CamlockFOVFrameNew then CamlockFOVFrameNew:Destroy() end end)
    pcall(function() heartbeatConnection:Disconnect() end)
    pcall(function() camlockConnection:Disconnect() end)
    pcall(function() triggerbotConnection:Disconnect() end)
    pcall(function() hitboxConnection:Disconnect() end)
    pcall(function() clearAllHitboxes() end)
    for _, connection in pairs(nameState.elementConnections) do
        pcall(function() connection:Disconnect() end)
    end
    for _, connection in pairs(nameState.containerConnections) do
        pcall(function() connection:Disconnect() end)
    end
    for _, connection in pairs(nameState.playerConnections) do
        pcall(function() connection:Disconnect() end)
    end
    local pg = player:FindFirstChild("PlayerGui")
    if pg and pg:FindFirstChild("ESP_UI") then
        pg.ESP_UI:Destroy()
    end
    if screenGui then
        screenGui:Destroy()
    end
end)




-- ==========================================
-- EXTRA: Externo + Juegos compatibles
-- ==========================================
;(function()
    local BASE_SCRIPTS = "https://raw.githubusercontent.com/Israel-Vortex/FlexusHub-Team/refs/heads/main/Scripts-Flexus/Top-one/"
    local AVATAR_URL = BASE_SCRIPTS .. "AvatarCopier.lua"

    local GAMES = {
        {
            Name = "Duels",
            Desc = "Asesinos VS Sheriffs · combate, ESP, farm y más.",
            PlaceId = 135856908115931,
            GameId = 7219654364,
        },
        {
            Name = "MM2",
            Desc = "Murder Mystery 2 · roles, farm y utilidades.",
            PlaceId = 142823291,
            GameId = nil,
        },
        {
            Name = "Steal an Egg",
            Desc = "Steal an Egg · farm, steal y herramientas.",
            PlaceId = 107778070777162,
            GameId = nil,
        },
        {
            Name = "Survival Disaster",
            Desc = "Natural Disaster Survival · fly, aura de items y utilidades.",
            PlaceId = 189707,
            GameId = nil,
        },
    }

    local function isCurrentGame(g)
        if g.GameId and tonumber(game.GameId) == tonumber(g.GameId) then
            return true
        end
        if tonumber(game.PlaceId) == tonumber(g.PlaceId) then
            return true
        end
        return false
    end

    local function currentGameName()
        for _, g in ipairs(GAMES) do
            if isCurrentGame(g) then
                return g.Name
            end
        end
        return "Desconocido"
    end

    local function safeNotify(title, content)
        pcall(function()
            if type(notify) == "function" then
                notify({ Title = title, Content = content, Duration = 3 })
            elseif WindUI and WindUI.Notify then
                WindUI:Notify({ Title = title, Content = content, Duration = 3 })
            end
        end)
    end

    local extraTab = Window:Tab({
        Title = "Extra",
        Icon = "package",
        ShowTabTitle = true,
        Border = true,
    })

    -- ----- Externo -----
    extraTab:Section({ Title = "Externo", Icon = "external-link" })

    extraTab:Paragraph({
        Title = "Herramientas externas",
        Desc = "Utilidades que se cargan aparte del hub de Duels.",
    })

    extraTab:Button({
        Title = "Avatar Copier",
        Desc = "Abre FlexusHub Avatar Copi en este servidor (copiar, guardar y restaurar avatares).",
        Callback = function()
            safeNotify("Externo", "Cargando Avatar Copier...")
            task.spawn(function()
                local ok, err = pcall(function()
                    local src = game:HttpGet(AVATAR_URL)
                    loadstring(src)()
                end)
                if not ok then
                    safeNotify("Externo", "No se pudo cargar Avatar Copier. Sube AvatarCopier.lua al repositorio.")
                    warn("[FlexusHub] AvatarCopier:", err)
                else
                    safeNotify("Externo", "Avatar Copier listo.")
                end
            end)
        end,
    })

    -- ----- Juegos compatibles (solo lista informativa) -----
    extraTab:Divider()
    extraTab:Section({ Title = "Juegos compatibles", Icon = "gamepad-2" })

    extraTab:Paragraph({
        Title = "Juego actual",
        Desc = "Estás en: " .. currentGameName() .. ".\n"
            .. "FlexusHub tiene script propio para los juegos de la lista. Usa el loader para cargarlos.",
    })

    for _, g in ipairs(GAMES) do
        local here = isCurrentGame(g)
        local title = g.Name
        local desc = g.Desc
        if here then
            title = g.Name .. " (actual)"
            desc = g.Desc .. " · Estás en este juego ahora."
        end

        extraTab:Paragraph({
            Title = title,
            Desc = desc,
        })
    end
end)()



-- ==========================================
-- AUTO REJOIN / SERVER HOP: re-ejecutar script
-- ==========================================
pcall(function()
    local queue = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
        or (queueonteleport)
    if not queue then return end
    local DUELS_URL = "https://raw.githubusercontent.com/Israel-Vortex/FlexusHub-Team/refs/heads/main/Scripts-Flexus/Top-one/Duels.lua"
    local code = [[
        if not game:IsLoaded() then game.Loaded:Wait() end
        task.wait(1.5)
        local ok, err = pcall(function()
            loadstring(game:HttpGet("]] .. DUELS_URL .. [["))()
        end)
        if not ok then warn("[FlexusHub] auto-rejoin load fail:", err) end
    ]]
    queue(code)
end)

-- Guardar al cerrar el juego / teleport
pcall(function()
    game:GetService("Players").LocalPlayer.OnTeleport:Connect(function()
        pcall(function() if vxsSaveConfig then vxsSaveConfig() end end)
    end)
end)

end)()
