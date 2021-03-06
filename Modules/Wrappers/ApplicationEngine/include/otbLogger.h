/*
 * Copyright (C) 2005-2017 Centre National d'Etudes Spatiales (CNES)
 *
 * This file is part of Orfeo Toolbox
 *
 *     https://www.orfeo-toolbox.org/
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef otbLogger_h
#define otbLogger_h

#include "itkLoggerBase.h"
#include "itkLogger.h"

namespace otb {

/** \class Logger
 *  \brief An ITK logger specialized for OTB
 *
 *  Sets OTB wide settings in its constructor
 *
 * \ingroup OTBApplicationEngine
 */
class Logger : public itk::Logger
{
public:
  typedef Logger                          Self;
  typedef itk::Logger                     Superclass;
  typedef itk::SmartPointer< Self >       Pointer;
  typedef itk::SmartPointer< const Self > ConstPointer;

  itkTypeMacro(Logger, Object);
  itkNewMacro(Self);

  // Overwrite this to provide custom formatting of log entries
  std::string BuildFormattedEntry(itk::Logger::PriorityLevelType, std::string const&) ITK_OVERRIDE;

protected:
    Logger();
    virtual ~Logger();
}; // class Logger

} // namespace otb

#endif // otbLogger_h
