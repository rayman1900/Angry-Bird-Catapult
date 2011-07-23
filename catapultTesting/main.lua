local projectile = require("projectile")
local physics = require("physics")
local catapult = require("catapult")
--physics.setDrawMode( "hybrid" )
physics.start()

physics.setScale(60) --valeur physique pour les petits objets
physics.setGravity(0, 0) --Vue que la vue est de haut, il n'y a pas de vecteur de gravité

display.setStatusBar(display.HiddenStatusBar)

local background = display.newImage("paper_bkg.png", true)
background:scale(2,2)
background:rotate(90)


catapult.newCatapult(50, 280, "targetRouge.png")
catapult.newCatapult(display.contentWidth-70 ,280, "targetBleu.png")