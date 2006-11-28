/*=========================================================================

Program:   ORFEO Toolbox
Language:  C++
Date:      $Date$
Version:   $Revision$


Copyright (c) Centre National d'Etudes Spatiales. All rights reserved.
See OTBCopyright.txt for details.


This software is distributed WITHOUT ANY WARRANTY; without even 
the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR 
PURPOSE.  See the above copyright notices for more information.

=========================================================================*/
#include "itkExceptionObject.h"
#include "otbMorphologicalPyramidSegmentationFilter.h"
#include "otbOpeningClosingMorphologicalFilter.h"
#include "itkBinaryBallStructuringElement.h"
#include "otbMorphologicalPyramidAnalyseFilter.h"
#include "otbImageFileReader.h"
#include "otbImageFileWriter.h"
#include "otbImage.h"

int otbMorphologicalPyramidSegmentationFilter(int argc, char * argv[])
{
  try
    {
      const char* inputFilename = argv[1];
      const char* outputFilenamePrefix = argv[2];
      const char * outputFilenameSuffix = argv[3];
      const unsigned int numberOfIterations = atoi(argv[4]);
      const double subSampleScale = atof(argv[5]);
      const float seedsQuantile = atof(argv[6]);
      const float segmentationQuantile = atof(argv[7]);
      const unsigned int minObjectSize = atoi(argv[8]);

      const unsigned int Dimension = 2;
      typedef unsigned char InputPixelType;
      typedef unsigned short OutputPixelType;

      typedef otb::Image<InputPixelType,Dimension> InputImageType;
      typedef otb::Image<OutputPixelType,Dimension> OutputImageType;

      typedef otb::ImageFileReader<InputImageType> ReaderType;
      typedef otb::ImageFileWriter<OutputImageType> WriterType;
      
      typedef itk::BinaryBallStructuringElement<InputPixelType,Dimension> StructuringElementType;
      typedef otb::OpeningClosingMorphologicalFilter<InputImageType,InputImageType,StructuringElementType>
	OpeningClosingFilterType;
      typedef otb::MorphologicalPyramidAnalyseFilter<InputImageType,InputImageType,OpeningClosingFilterType>
	PyramidFilterType;
      typedef otb::MorphologicalPyramidSegmentationFilter<InputImageType,OutputImageType>
	SegmentationFilterType;
      typedef SegmentationFilterType::OutputImageListIteratorType OutputListIteratorType;

      // Input images reading
      ReaderType::Pointer reader = ReaderType::New();
      reader->SetFileName(inputFilename);

      //Analyse
      PyramidFilterType::Pointer pyramid = PyramidFilterType::New();
      pyramid->SetNumberOfIterations(numberOfIterations);
      pyramid->SetSubSampleScale(subSampleScale);
      pyramid->SetInput(reader->GetOutput());

      // Segmentation
      SegmentationFilterType::Pointer segmentation = SegmentationFilterType::New();
      segmentation->SetReferenceImage(reader->GetOutput());
      segmentation->SetBrighterDetails(pyramid->GetSupFiltre());
      segmentation->SetDarkerDetails(pyramid->GetInfFiltre());
      segmentation->SetSeedsQuantile(seedsQuantile);
      segmentation->SetConnectedThresholdQuantile(segmentationQuantile);
      segmentation->SetMinimumObjectSize(minObjectSize);
      segmentation->Update();

      // Output writing
      OutputListIteratorType it = segmentation->GetOutput()->Begin();
      WriterType::Pointer writer;
      int index = 1;
      std::stringstream oss;
      while(it!=segmentation->GetOutput()->End())
	{
	  oss<<outputFilenamePrefix<<index<<"."<<outputFilenameSuffix;
	  writer = WriterType::New();
	  writer->SetInput(it.Get());
	  writer->SetFileName(oss.str().c_str());	  
	  writer->Update();
	  std::cout<<oss.str()<<" file written."<<std::endl;
	  oss.str("");
	  ++index;
	  ++it;
	}
    }
      catch( itk::ExceptionObject & err ) 
	{ 
	  std::cout << "Exception itk::ExceptionObject thrown !" << std::endl;
	  std::cout << err << std::endl; 
	  return EXIT_FAILURE;
	} 

      catch( ... ) 
	{ 
	  std::cout << "Unknown exception thrown !" << std::endl; 
	  return EXIT_FAILURE;
	} 

      return EXIT_SUCCESS;
    }
