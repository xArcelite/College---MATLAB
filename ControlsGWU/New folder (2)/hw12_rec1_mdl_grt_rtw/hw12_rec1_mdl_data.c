/*
 * hw12_rec1_mdl_data.c
 *
 * Academic Student License -- for use by students to meet course
 * requirements and perform academic research at degree granting
 * institutions only.  Not for government, commercial, or other
 * organizational use.
 *
 * Code generation for model "hw12_rec1_mdl".
 *
 * Model version              : 1.4
 * Simulink Coder version : 8.13 (R2017b) 24-Jul-2017
 * C source code generated on : Thu Dec  7 16:22:00 2017
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: 32-bit Generic
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "hw12_rec1_mdl.h"
#include "hw12_rec1_mdl_private.h"

/* Block parameters (auto storage) */
P_hw12_rec1_mdl_T hw12_rec1_mdl_P = {
  /* Computed Parameter: TransferFcn_A
   * Referenced by: '<Root>/Transfer Fcn'
   */
  { -0.5, -0.0 },

  /* Computed Parameter: TransferFcn_C
   * Referenced by: '<Root>/Transfer Fcn'
   */
  { 0.0, 0.5 },

  /* Expression: 0
   * Referenced by: '<Root>/Step'
   */
  0.0,

  /* Expression: 0
   * Referenced by: '<Root>/Step'
   */
  0.0,

  /* Expression: 1
   * Referenced by: '<Root>/Step'
   */
  1.0,

  /* Expression: 0.15
   * Referenced by: '<Root>/Gain'
   */
  0.15,

  /* Expression: 3
   * Referenced by: '<Root>/Transport Delay'
   */
  3.0,

  /* Expression: 0
   * Referenced by: '<Root>/Transport Delay'
   */
  0.0
};
