--[[----------------------------------------------------------------------------
  Application Name:
  OCRTraining_HALCON

  Summary:
  Example for OCR training within AppSpace using the HALCON API.

  Description:
  This App shows how to train an OCR handle based on a given training image and
  label file which contains the identified characters of the training image.
  The labels are sorted line wise (from left to right and from top to bottom).
  The output of this sample is a trained OCR handle file in public AppData which
  then can be used in the OCRReading_HALCON sample.

  How to run:
  To run this sample a device which has HALCON integrated is necessary.
  Implementation:
  This sample is written using HALCON 12.
  
------------------------------------------------------------------------------]]

--Start of Function and Event Scope---------------------------------------------

--@trainOCR(trainingImage:Image, trainingLabels:table, trainedOCRFilename:string)
local function trainOCR(trainingImage, trainingLabels, trainedOCRFilename)
  local trainingFilename = "letters.trf"
  -- Creating Halcon handle
  local hdevOCRTraining = Halcon.create()
  -- Loading OCRTraining.hdvp script into HALCON handle
  hdevOCRTraining:loadProcedure("resources/OCRTraining.hdvp")
  
  -- Setting the iconic and control input parameters of the HALCON function OCRTraining.hdvp
  hdevOCRTraining:setImage("TrainingImage", trainingImage)
  hdevOCRTraining:setString("OCRTrainingFilename", trainingFilename)
  hdevOCRTraining:setString("OCRFilename", trainedOCRFilename)
  hdevOCRTraining:setStringArray("Labels", trainingLabels)
  
  -- Executing the loaded function
  local _ = hdevOCRTraining:execute()
  File.del("public/" .. trainingFilename)
  print("Training finished, see output at public/" .. trainedOCRFilename)
end

--Declaration of the 'main' function as an entry point for the event loop
local function main()
  --Specifiying path for storing ocr handle
  local relativePath = "ocrhandle.ocm"
  -- Loading the training image
  local trainingImage = Image.load("resources/sicklogo.bmp")
  -- Loading label file
  local labelFileHandle = File.open("resources/LabelFile.txt", "r")
  local trainingLabelsString = File.read(labelFileHandle)
  -- Removing line breaks in labels
  local trainingLabelsTable = {}
  trainingLabelsString:gsub(".",
  function(c)
      if(c:match("%w")) then
      table.insert(trainingLabelsTable,c)
    end
  end)
  -- Training OCR handle by calling trainOCR
  trainOCR(trainingImage, trainingLabelsTable, relativePath)
  print("App finished.")
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register("Engine.OnStarted", main)

--End of Function and Event Scope-----------------------------------------------
