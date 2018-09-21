/*==============================================================================

Copyright (c) Laboratory for Percutaneous Surgery (PerkLab)
Queen's University, Kingston, ON, Canada. All Rights Reserved.

See COPYRIGHT.txt
or http://www.slicer.org/copyright/copyright.txt for details.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

This file was originally developed by Kyle Sunderland, PerkLab, Queen's University
and was supported through the Applied Cancer Research Unit program of Cancer Care
Ontario with funds provided by the Ontario Ministry of Health and Long-Term Care

==============================================================================*/

#ifndef __qSlicerVideoIOModule_h
#define __qSlicerVideoIOModule_h

// SlicerQt includes
#include "qSlicerLoadableModule.h"
#include "qSlicerVideoIOModuleExport.h"
#include "qSlicerApplication.h"

class qSlicerVideoIOModulePrivate;
class vtkObject;

/// \ingroup Slicer_QtModules_VideoIO
class Q_SLICER_QTMODULES_VIDEOIO_EXPORT qSlicerVideoIOModule :
  public qSlicerLoadableModule
{
  Q_OBJECT;
  QVTK_OBJECT;
#ifdef Slicer_HAVE_QT5
  Q_PLUGIN_METADATA(IID "org.slicer.modules.loadable.qSlicerLoadableModule/1.0");
#endif
  Q_INTERFACES(qSlicerLoadableModule);

public:

  typedef qSlicerLoadableModule Superclass;
  explicit qSlicerVideoIOModule(QObject *parent=0);
  virtual ~qSlicerVideoIOModule();

  qSlicerGetTitleMacro(QTMODULE_TITLE);

  /// Help to use the module
  virtual QString helpText()const;

  /// Return acknowledgements
  virtual QString acknowledgementText()const;

  /// Return a custom icon for the module
  virtual QIcon icon()const;

  /// Module category
  virtual QStringList categories()const;

  /// Dependencies on other Slicer modules
  virtual QStringList dependencies()const;

protected:

  /// Initialize the module. Register the volumes reader/writer
  virtual void setup();

  /// Create and return the widget representation associated to this module
  virtual qSlicerAbstractModuleRepresentation * createWidgetRepresentation();

  /// Create and return the logic associated to this module
  virtual vtkMRMLAbstractLogic* createLogic();

public slots:
  virtual void setMRMLScene(vtkMRMLScene*);

protected:
  QScopedPointer<qSlicerVideoIOModulePrivate> d_ptr;

private:
  Q_DECLARE_PRIVATE(qSlicerVideoIOModule);
  Q_DISABLE_COPY(qSlicerVideoIOModule);

};

#endif
