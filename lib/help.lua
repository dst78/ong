Help = {}

Help.texts = {
  {"K1", "display help"},
  {"E1", "overall amplitude"},
  {"E2", "near waves amplitude"},
  {"K2+E2", "near waves speed"},
  {"K3+E2", "foam amplitude"},
  {"E3", "far waves amplitude"},
  {"K2+E3", "far waves speed"},
  {"K3+E3", "ambience amplitude"}
}
Help.lineText = ""
Help.lineFrame = 0

function Help.display()
  screen.font_face(1)
  screen.font_size(8)

  screen.level(15)
  screen.move(0, 6)
  screen.text("ONG")

  for i = 1,8 do
    screen.move(5, 6 + (i*7))
    screen.level(10)
    screen.text(Help.texts[i][1])
    screen.move(35, 6 + (i*7))
    screen.level(5)
    screen.text(Help.texts[i][2])
  end
end

function Help.displayLine()
  if Counters.getFrame() > Help.lineFrame then
    Help.lineText = ""
  end

  if Help.lineText ~= "" then
    screen.font_face(1)
    screen.font_size(8)
    screen.level(15)
    screen.move(0, 6)
    screen.text(Help.lineText)
  end
end

function Help.line(key, val)
  for i = 1,8 do
    if Help.texts[i][1] == key then
      Help.lineText = Help.texts[i][2] .. ": " .. val
      Help.lineFrame = Counters.getFrame() + 30
    end
  end
end

function Help.clearLine()
  Help.lineText = ""
end

return Help
