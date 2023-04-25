
--Start of Global Scope---------------------------------------------------------

Script.serveEvent('Gauss3D.OnMessage1', 'OnMessage1')
Script.serveEvent('Gauss3D.OnMessage2', 'OnMessage2')

-- Create viewer for original and filtered 3D image

local viewer1 = View.create('viewer3D1') -- Will show in 3D viewer
local viewer2 = View.create('viewer3D2') -- Will show in 3D viewer
local imDeco = View.ImageDecoration.create():setRange(36, 157)

--End of Global Scope-----------------------------------------------------------

-- Start of Function and Event Scope--------------------------------------------

---@param heightMap Image
---@param intensityMap Image
local function filteringImage(heightMap, intensityMap)
  -- GAUSS: Applies a Gaussian filter to smooth an image

  -- Visualize the input (original image)
  viewer1:clear()
  viewer1:addHeightmap({heightMap, intensityMap}, imDeco, {'Reflectance'})
  viewer1:present()
  Script.notifyEvent('OnMessage1', 'Original image')

  -- Filter on the heightMap
  local kernelsize = 5 -- Size of the kernel, must be positive and odd
  local gaussImage = heightMap:gauss(kernelsize) -- Gauss filtering
  local gaussintensityMap = intensityMap:gauss(kernelsize) -- Gauss filtering

  -- Visualize the output (gauss image)
  viewer2:clear()
  viewer2:addHeightmap({gaussImage, gaussintensityMap}, imDeco, {'Reflectance'})
  viewer2:present()

  Script.notifyEvent('OnMessage2', 'Gauss filter, kernel size: ' .. kernelsize)
end

local function main()
  -- Load a json-image
  local data = Object.load('resources/image_23.json')

  -- Extract heightmap, intensity map and sensor data
  local heightMap = data[1]
  local intensityMap = data[2]
  local sensorData = data[3] --luacheck: ignore

  -- Filter image
  filteringImage(heightMap, intensityMap)
  print('App finished')
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

--End of Function and Event Scope--------------------------------------------------
