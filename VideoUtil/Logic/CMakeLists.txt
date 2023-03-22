project(vtkSlicer${MODULE_NAME}ModuleLogic)

set(KIT "${PROJECT_NAME}")

find_package(IGSIO REQUIRED)

set(${KIT}_EXPORT_DIRECTIVE "VTK_SLICER_${MODULE_NAME_UPPER}_MODULE_LOGIC_EXPORT")

set(${KIT}_INCLUDE_DIRECTORIES
  ${vtkSlicerSequencesModuleMRML_INCLUDE_DIRS}
  ${VTKSEQUENCEIO_INCLUDE_DIRS}
  ${Slicer_INSTALL_QTLOADABLEMODULES_INCLUDE_DIR}/vtkSlicerSequencesModuleMRML
  )

set(${KIT}_SRCS
  vtkSlicer${MODULE_NAME}Logic.cxx
  vtkSlicer${MODULE_NAME}Logic.h
  )

set(${KIT}_TARGET_LIBRARIES
  ${VTK_LIBRARIES}
  vtkSlicerSequencesModuleMRML
  vtkSlicerSequenceIOModuleMRML
  )

set(DISABLE_WRAP_PYTHON DISABLE_WRAP_PYTHON)
if (Slicer_USE_PYTHONQT)
  set(DISABLE_WRAP_PYTHON)
  list(APPEND ${KIT}_TARGET_LIBRARIES ${Python3_LIBRARIES})
endif()

#-----------------------------------------------------------------------------
SlicerMacroBuildModuleLogic(
  NAME ${KIT}
  EXPORT_DIRECTIVE ${${KIT}_EXPORT_DIRECTIVE}
  INCLUDE_DIRECTORIES ${${KIT}_INCLUDE_DIRECTORIES}
  SRCS ${${KIT}_SRCS}
  TARGET_LIBRARIES ${${KIT}_TARGET_LIBRARIES}
  ${DISABLE_WRAP_PYTHON}
  )


foreach(p IN LISTS ${KIT}_INCLUDE_DIRECTORIES)
  target_include_directories(${KIT} PUBLIC $<BUILD_INTERFACE:${p}>)
endforeach()
foreach(p IN LISTS ${KIT}_INCLUDE_DIRS)
  target_include_directories(${KIT} PUBLIC $<BUILD_INTERFACE:${p}>)
endforeach()
target_include_directories(${KIT} PUBLIC $<INSTALL_INTERFACE:${${KIT}_INSTALL_INCLUDE_DIR}>)
