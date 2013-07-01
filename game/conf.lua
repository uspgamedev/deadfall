function love.conf(t)
  t.title   = "Deadfall"
  --t.version = "0.0.1"
  t.console = true
  t.release = false

  t.screen.width      = 1024
  t.screen.height     = 768
  t.screen.fullscreen = false
  t.screen.vsync      = false
  t.screen.fsaa       = 8

  t.modules.joystick  = false
  t.modules.physics   = false
  t.modules.audio     = true
  t.modules.keyboard  = true
  t.modules.event     = true
  t.modules.image     = true
  t.modules.graphics  = true
  t.modules.timer     = true
  t.modules.mouse     = true
  t.modules.sound     = true
end