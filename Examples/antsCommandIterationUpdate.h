/*=========================================================================
 *
 * Code adapted from itkCommandIterationUpdatev4.h
 *
 *  Copyright NumFOCUS
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *         https://www.apache.org/licenses/LICENSE-2.0.txt
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *=========================================================================*/
#ifndef antsCommandIterationUpdate_h
#define antsCommandIterationUpdate_h

#include "itkCommand.h"
#include "itkWeakPointer.h"

namespace ants
{

/**
 * \class CommandIterationUpdate
 * \brief Implementation of the Command Pattern to be invoked every iteration
 * \ingroup ITKOptimizersv4
 */
template <typename TOptimizer>
class antsCommandIterationUpdate  : public itk::Command
{
public:
  /**
   * Standard "Self" typedef.
   */
  using Self = antsCommandIterationUpdate;


  /**
   * Standard "Superclass" typedef.
   */
  using Superclass = itk::Command;


  /**
   * Smart pointer type alias support
   */
  using Pointer = itk::SmartPointer<Self>;

  /**
   * ConstSmart pointer type alias support
   */
  using ConstPointer = itk::SmartPointer<const Self>;

  /**
   * Execute method will print data at each iteration
   */
  void
  Execute(itk::Object * caller, const itk::EventObject & event) override
  {
    Execute((const itk::Object *)caller, event);
  }

   void
  Execute(const itk::Object *, const itk::EventObject & event) override
  {
    if (typeid(event) == typeid(itk::StartEvent))
    {
      // Can't call m_Optimizer->GetNumberOfIterations() because that's not set correctly until
      // optimization begins
      this->SetTotalNumberOfIterations(static_cast<unsigned int>(m_Optimizer->GetParametersList().size()));
      std::cout << std::endl << "Iteration,MetricValue";
      if (m_PrintParameters)
        {
          std::cout << ",Parameters";
        }
      std::cout << std::endl;
    }
    else if (typeid(event) == typeid(itk::IterationEvent))
    {
      // Count iterations from 1
      std::cout << (m_Optimizer->GetCurrentIteration() + 1) << "/" << m_TotalNumberOfIterations << ",";
      std::cout << m_Optimizer->GetValue();
      if (m_PrintParameters)
      {
        std::cout << "," << m_Optimizer->GetCurrentPosition();
      }
      std::cout << std::endl;
    }
  }



  /**
   * Run-time type information (and related methods).
   */
  itkTypeMacro(antsCommandIterationUpdate, itk::Command);


  /**
   * Method for creation through the object factory.
   */
  itkNewMacro(Self);


  /**
   * Type defining the optimizer
   */
  using OptimizerType = TOptimizer;


  /**
   * Set Optimizer
   */
  void
  SetOptimizer(OptimizerType * optimizer)
  {
    m_Optimizer = optimizer;
    m_Optimizer->AddObserver(itk::IterationEvent(), this);
  }

  /**
   * Print parameters at each iteration
   */
  itkSetMacro(PrintParameters, bool);
  itkGetMacro(PrintParameters, bool);
  itkBooleanMacro(PrintParameters);


protected:
  /**
   * Constructor
   */
  antsCommandIterationUpdate(){};

  itkSetMacro(TotalNumberOfIterations, unsigned int);
  itkGetMacro(TotalNumberOfIterations, unsigned int);

private:
  /**
   *  WeakPointer to the Optimizer
   */
  itk::WeakPointer<OptimizerType> m_Optimizer;

  bool m_PrintParameters{ false };

  unsigned int m_TotalNumberOfIterations{0};
};

} // end namespace ants

#endif