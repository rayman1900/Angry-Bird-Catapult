module(..., package.seeall)

function newCatapult( _x, _y, equipeColor )
	
--Groupe visible
local slingshot_container = display.newGroup();

local poteau_haut = display.newImage( "slingshot_pole_unique.png")
poteau_haut.x = _x; poteau_haut.y = _y; poteau_haut:scale(2,2)
slingshot_container:insert(poteau_haut)

local poteau_bas = display.newImage("slingshot_pole_unique.png")
poteau_bas.x = _x; poteau_bas.y = _y + 200; poteau_bas:scale(2,2)
slingshot_container:insert(poteau_bas)

local elastique = display.newLine(poteau_haut.x, poteau_haut.y, poteau_bas.x, poteau_bas.y)
-- Set the elastic band's visual attributes
elastique:setColor(214,184,130);
elastique.width = 6;
slingshot_container:insert(elastique)

--On cree notre boule de neige
local ball = projectile.newProjectile()
ball.x = _x; ball.y = _y+100
slingshot_container:insert(ball)

--On crée la cible vituelle autour de la balle
local target = display.newImage( equipeColor)
target.x = ball.x; target.y = ball.y; target.alpha = 0
slingshot_container:insert(target)

local function dragCatapult( event )
	local t = event.target
	
	local phase = event.phase
	if "began" == phase then
		display.getCurrentStage():setFocus(t)
		t.isFocus = true
		
		--On stoppe tout mouvement de la balle
		t:setLinearVelocity(0,0)
		t.angularVelocity = 0
		--cible par rapport à la balle
		target.x = t.x
		target.y = t.y
		--position initiale au toucher            
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y
		
		--petite fonction gérant l'animation de la cible
		startRotation = function()
		target.rotation = target.rotation + 4
	end
	Runtime:addEventListener("enterFrame", startRotation)
	
	--affichage de la cible au toucher       
	local showTarget = transition.to(target, {alpha = 0.4, time = 200, yScale = 0.4, xScale = 0.4})
	--Ne pas oublier de spécifier que la ligne est null
	myLine = nil
	--lignes de slingshot
	line_up = nil
	line_down = nil
	
elseif t.isFocus then
	
	--On cache l'elastique de départ
	elastique.isVisible = false
	
	if "moved" == phase then
		--Si la ligne existe, efface-la
		if (myLine) then
			myLine.parent:remove(myLine)
			line_up.parent:remove(line_up)
			line_down.parent:remove(line_down) 
		end
		
		-- la balle suit le toucher...
		t.x = event.x - t.x0
		t.y = event.y - t.y0
		
		--Set the elastic attached to the touch
		line_up = display.newLine(t.x, t.y, poteau_haut.x, poteau_haut.y)
		line_down = display.newLine(t.x, t.y, poteau_bas.x, poteau_bas.y)
		-- Set the elastic band's visual attributes
		line_up:setColor(214,184,130);
		line_up.width = 4;

		line_down:setColor(243,207,134);
		line_down.width = 4;
		--Set the target line visual attributes
		myLine = display.newLine(t.x, t.y, target.x, target.y)
		myLine:setColor(0,0,0,50)
		myLine.width = 8
		
elseif "ended" == phase or "cancelled" == phase then
	-- relâche le focus
	display.getCurrentStage():setFocus( nil ) 
	t.isFocus = false
	--Fonction arrêtant la cible de tourner
	local stopRotation = function()
	Runtime:removeEventListener("enterFrame", startRotation)
end
--Utilisation de la fonction stopRotation après que la cible est disparu
local hideTarget = transition.to(target, {alpha = 0, time = 200, yScale = 1.0, xScale = 1.0, onComplete=stopRotation})

--On fait réaparaître l'élastique de départ
elastique.isVisible = true

--On efface toutes les lignes
if (myLine) then
	myLine.parent:remove(myLine)
	line_up.parent:remove(line_up)
	line_down.parent:remove(line_down)
	line_up = nil
	line_down = nil
end
--Envoie de la balle
--On applique la force selon la distance entre la balle et la cible * -600 vue que c'est un lancer dans la direction contraire...
t:applyForce((t.x - target.x)*-600, (t.y - target.y)* -600, t.x, t.y)

end
end

return true

end

local function toucheLimite( event )
	if ball.x > display.contentWidth+200 or ball.x < -200 or ball.y < -200 or ball.y > display.contentHeight+200 then
    ball:setLinearVelocity(0,0)
    ball.angularVelocity = 0
	ball.x = _x
	ball.y = _y+100

	end	
end

Runtime:addEventListener("enterFrame", toucheLimite)
ball:addEventListener("touch", dragCatapult )

return slingshot_container

end