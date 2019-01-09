/*
 * hw12_rec1_mdl.c
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

/* Block signals (auto storage) */
B_hw12_rec1_mdl_T hw12_rec1_mdl_B;

/* Continuous states */
X_hw12_rec1_mdl_T hw12_rec1_mdl_X;

/* Block states (auto storage) */
DW_hw12_rec1_mdl_T hw12_rec1_mdl_DW;

/* Real-time model */
RT_MODEL_hw12_rec1_mdl_T hw12_rec1_mdl_M_;
RT_MODEL_hw12_rec1_mdl_T *const hw12_rec1_mdl_M = &hw12_rec1_mdl_M_;

/*
 * Time delay interpolation routine
 *
 * The linear interpolation is performed using the formula:
 *
 *          (t2 - tMinusDelay)         (tMinusDelay - t1)
 * u(t)  =  ----------------- * u1  +  ------------------- * u2
 *              (t2 - t1)                  (t2 - t1)
 */
real_T rt_TDelayInterpolate(
  real_T tMinusDelay,                  /* tMinusDelay = currentSimTime - delay */
  real_T tStart,
  real_T *tBuf,
  real_T *uBuf,
  int_T bufSz,
  int_T *lastIdx,
  int_T oldestIdx,
  int_T newIdx,
  real_T initOutput,
  boolean_T discrete,
  boolean_T minorStepAndTAtLastMajorOutput)
{
  int_T i;
  real_T yout, t1, t2, u1, u2;

  /*
   * If there is only one data point in the buffer, this data point must be
   * the t= 0 and tMinusDelay > t0, it ask for something unknown. The best
   * guess if initial output as well
   */
  if ((newIdx == 0) && (oldestIdx ==0 ) && (tMinusDelay > tStart))
    return initOutput;

  /*
   * If tMinusDelay is less than zero, should output initial value
   */
  if (tMinusDelay <= tStart)
    return initOutput;

  /* For fixed buffer extrapolation:
   * if tMinusDelay is small than the time at oldestIdx, if discrete, output
   * tailptr value,  else use tailptr and tailptr+1 value to extrapolate
   * It is also for fixed buffer. Note: The same condition can happen for transport delay block where
   * use tStart and and t[tail] other than using t[tail] and t[tail+1].
   * See below
   */
  if ((tMinusDelay <= tBuf[oldestIdx] ) ) {
    if (discrete) {
      return(uBuf[oldestIdx]);
    } else {
      int_T tempIdx= oldestIdx + 1;
      if (oldestIdx == bufSz-1)
        tempIdx = 0;
      t1= tBuf[oldestIdx];
      t2= tBuf[tempIdx];
      u1= uBuf[oldestIdx];
      u2= uBuf[tempIdx];
      if (t2 == t1) {
        if (tMinusDelay >= t2) {
          yout = u2;
        } else {
          yout = u1;
        }
      } else {
        real_T f1 = (t2-tMinusDelay) / (t2-t1);
        real_T f2 = 1.0 - f1;

        /*
         * Use Lagrange's interpolation formula.  Exact outputs at t1, t2.
         */
        yout = f1*u1 + f2*u2;
      }

      return yout;
    }
  }

  /*
   * When block does not have direct feedthrough, we use the table of
   * values to extrapolate off the end of the table for delays that are less
   * than 0 (less then step size).  This is not completely accurate.  The
   * chain of events is as follows for a given time t.  Major output - look
   * in table.  Update - add entry to table.  Now, if we call the output at
   * time t again, there is a new entry in the table. For very small delays,
   * this means that we will have a different answer from the previous call
   * to the output fcn at the same time t.  The following code prevents this
   * from happening.
   */
  if (minorStepAndTAtLastMajorOutput) {
    /* pretend that the new entry has not been added to table */
    if (newIdx != 0) {
      if (*lastIdx == newIdx) {
        (*lastIdx)--;
      }

      newIdx--;
    } else {
      if (*lastIdx == newIdx) {
        *lastIdx = bufSz-1;
      }

      newIdx = bufSz - 1;
    }
  }

  i = *lastIdx;
  if (tBuf[i] < tMinusDelay) {
    /* Look forward starting at last index */
    while (tBuf[i] < tMinusDelay) {
      /* May occur if the delay is less than step-size - extrapolate */
      if (i == newIdx)
        break;
      i = ( i < (bufSz-1) ) ? (i+1) : 0;/* move through buffer */
    }
  } else {
    /*
     * Look backwards starting at last index which can happen when the
     * delay time increases.
     */
    while (tBuf[i] >= tMinusDelay) {
      /*
       * Due to the entry condition at top of function, we
       * should never hit the end.
       */
      i = (i > 0) ? i-1 : (bufSz-1);   /* move through buffer */
    }

    i = ( i < (bufSz-1) ) ? (i+1) : 0;
  }

  *lastIdx = i;
  if (discrete) {
    /*
     * tempEps = 128 * eps;
     * localEps = max(tempEps, tempEps*fabs(tBuf[i]))/2;
     */
    double tempEps = (DBL_EPSILON) * 128.0;
    double localEps = tempEps * fabs(tBuf[i]);
    if (tempEps > localEps) {
      localEps = tempEps;
    }

    localEps = localEps / 2.0;
    if (tMinusDelay >= (tBuf[i] - localEps)) {
      yout = uBuf[i];
    } else {
      if (i == 0) {
        yout = uBuf[bufSz-1];
      } else {
        yout = uBuf[i-1];
      }
    }
  } else {
    if (i == 0) {
      t1 = tBuf[bufSz-1];
      u1 = uBuf[bufSz-1];
    } else {
      t1 = tBuf[i-1];
      u1 = uBuf[i-1];
    }

    t2 = tBuf[i];
    u2 = uBuf[i];
    if (t2 == t1) {
      if (tMinusDelay >= t2) {
        yout = u2;
      } else {
        yout = u1;
      }
    } else {
      real_T f1 = (t2-tMinusDelay) / (t2-t1);
      real_T f2 = 1.0 - f1;

      /*
       * Use Lagrange's interpolation formula.  Exact outputs at t1, t2.
       */
      yout = f1*u1 + f2*u2;
    }
  }

  return(yout);
}

/*
 * This function updates continuous states using the ODE3 fixed-step
 * solver algorithm
 */
static void rt_ertODEUpdateContinuousStates(RTWSolverInfo *si )
{
  /* Solver Matrices */
  static const real_T rt_ODE3_A[3] = {
    1.0/2.0, 3.0/4.0, 1.0
  };

  static const real_T rt_ODE3_B[3][3] = {
    { 1.0/2.0, 0.0, 0.0 },

    { 0.0, 3.0/4.0, 0.0 },

    { 2.0/9.0, 1.0/3.0, 4.0/9.0 }
  };

  time_T t = rtsiGetT(si);
  time_T tnew = rtsiGetSolverStopTime(si);
  time_T h = rtsiGetStepSize(si);
  real_T *x = rtsiGetContStates(si);
  ODE3_IntgData *id = (ODE3_IntgData *)rtsiGetSolverData(si);
  real_T *y = id->y;
  real_T *f0 = id->f[0];
  real_T *f1 = id->f[1];
  real_T *f2 = id->f[2];
  real_T hB[3];
  int_T i;
  int_T nXc = 2;
  rtsiSetSimTimeStep(si,MINOR_TIME_STEP);

  /* Save the state values at time t in y, we'll use x as ynew. */
  (void) memcpy(y, x,
                (uint_T)nXc*sizeof(real_T));

  /* Assumes that rtsiSetT and ModelOutputs are up-to-date */
  /* f0 = f(t,y) */
  rtsiSetdX(si, f0);
  hw12_rec1_mdl_derivatives();

  /* f(:,2) = feval(odefile, t + hA(1), y + f*hB(:,1), args(:)(*)); */
  hB[0] = h * rt_ODE3_B[0][0];
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0]);
  }

  rtsiSetT(si, t + h*rt_ODE3_A[0]);
  rtsiSetdX(si, f1);
  hw12_rec1_mdl_step();
  hw12_rec1_mdl_derivatives();

  /* f(:,3) = feval(odefile, t + hA(2), y + f*hB(:,2), args(:)(*)); */
  for (i = 0; i <= 1; i++) {
    hB[i] = h * rt_ODE3_B[1][i];
  }

  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0] + f1[i]*hB[1]);
  }

  rtsiSetT(si, t + h*rt_ODE3_A[1]);
  rtsiSetdX(si, f2);
  hw12_rec1_mdl_step();
  hw12_rec1_mdl_derivatives();

  /* tnew = t + hA(3);
     ynew = y + f*hB(:,3); */
  for (i = 0; i <= 2; i++) {
    hB[i] = h * rt_ODE3_B[2][i];
  }

  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0] + f1[i]*hB[1] + f2[i]*hB[2]);
  }

  rtsiSetT(si, tnew);
  rtsiSetSimTimeStep(si,MAJOR_TIME_STEP);
}

/* Model step function */
void hw12_rec1_mdl_step(void)
{
  /* local block i/o variables */
  real_T rtb_Gain;
  real_T currentTime;
  if (rtmIsMajorTimeStep(hw12_rec1_mdl_M)) {
    /* set solver stop time */
    if (!(hw12_rec1_mdl_M->Timing.clockTick0+1)) {
      rtsiSetSolverStopTime(&hw12_rec1_mdl_M->solverInfo,
                            ((hw12_rec1_mdl_M->Timing.clockTickH0 + 1) *
        hw12_rec1_mdl_M->Timing.stepSize0 * 4294967296.0));
    } else {
      rtsiSetSolverStopTime(&hw12_rec1_mdl_M->solverInfo,
                            ((hw12_rec1_mdl_M->Timing.clockTick0 + 1) *
        hw12_rec1_mdl_M->Timing.stepSize0 + hw12_rec1_mdl_M->Timing.clockTickH0 *
        hw12_rec1_mdl_M->Timing.stepSize0 * 4294967296.0));
    }
  }                                    /* end MajorTimeStep */

  /* Update absolute time of base rate at minor time step */
  if (rtmIsMinorTimeStep(hw12_rec1_mdl_M)) {
    hw12_rec1_mdl_M->Timing.t[0] = rtsiGetT(&hw12_rec1_mdl_M->solverInfo);
  }

  /* TransferFcn: '<Root>/Transfer Fcn' */
  hw12_rec1_mdl_B.TransferFcn = 0.0;
  hw12_rec1_mdl_B.TransferFcn += hw12_rec1_mdl_P.TransferFcn_C[0] *
    hw12_rec1_mdl_X.TransferFcn_CSTATE[0];
  hw12_rec1_mdl_B.TransferFcn += hw12_rec1_mdl_P.TransferFcn_C[1] *
    hw12_rec1_mdl_X.TransferFcn_CSTATE[1];
  if (rtmIsMajorTimeStep(hw12_rec1_mdl_M)) {
  }

  /* Step: '<Root>/Step' */
  currentTime = hw12_rec1_mdl_M->Timing.t[0];
  if (currentTime < hw12_rec1_mdl_P.Step_Time) {
    currentTime = hw12_rec1_mdl_P.Step_Y0;
  } else {
    currentTime = hw12_rec1_mdl_P.Step_YFinal;
  }

  /* End of Step: '<Root>/Step' */

  /* Gain: '<Root>/Gain' incorporates:
   *  Sum: '<Root>/Sum'
   */
  rtb_Gain = (currentTime - hw12_rec1_mdl_B.TransferFcn) *
    hw12_rec1_mdl_P.Gain_Gain;

  /* TransportDelay: '<Root>/Transport Delay' */
  {
    real_T **uBuffer = (real_T**)
      &hw12_rec1_mdl_DW.TransportDelay_PWORK.TUbufferPtrs[0];
    real_T **tBuffer = (real_T**)
      &hw12_rec1_mdl_DW.TransportDelay_PWORK.TUbufferPtrs[1];
    real_T simTime = hw12_rec1_mdl_M->Timing.t[0];
    real_T tMinusDelay = simTime - hw12_rec1_mdl_P.TransportDelay_Delay;
    hw12_rec1_mdl_B.TransportDelay = rt_TDelayInterpolate(
      tMinusDelay,
      0.0,
      *tBuffer,
      *uBuffer,
      hw12_rec1_mdl_DW.TransportDelay_IWORK.CircularBufSize,
      &hw12_rec1_mdl_DW.TransportDelay_IWORK.Last,
      hw12_rec1_mdl_DW.TransportDelay_IWORK.Tail,
      hw12_rec1_mdl_DW.TransportDelay_IWORK.Head,
      hw12_rec1_mdl_P.TransportDelay_InitOutput,
      0,
      0);
  }

  if (rtmIsMajorTimeStep(hw12_rec1_mdl_M)) {
    /* Matfile logging */
    rt_UpdateTXYLogVars(hw12_rec1_mdl_M->rtwLogInfo, (hw12_rec1_mdl_M->Timing.t));
  }                                    /* end MajorTimeStep */

  if (rtmIsMajorTimeStep(hw12_rec1_mdl_M)) {
    /* Update for TransportDelay: '<Root>/Transport Delay' */
    {
      real_T **uBuffer = (real_T**)
        &hw12_rec1_mdl_DW.TransportDelay_PWORK.TUbufferPtrs[0];
      real_T **tBuffer = (real_T**)
        &hw12_rec1_mdl_DW.TransportDelay_PWORK.TUbufferPtrs[1];
      real_T simTime = hw12_rec1_mdl_M->Timing.t[0];
      hw12_rec1_mdl_DW.TransportDelay_IWORK.Head =
        ((hw12_rec1_mdl_DW.TransportDelay_IWORK.Head <
          (hw12_rec1_mdl_DW.TransportDelay_IWORK.CircularBufSize-1)) ?
         (hw12_rec1_mdl_DW.TransportDelay_IWORK.Head+1) : 0);
      if (hw12_rec1_mdl_DW.TransportDelay_IWORK.Head ==
          hw12_rec1_mdl_DW.TransportDelay_IWORK.Tail) {
        hw12_rec1_mdl_DW.TransportDelay_IWORK.Tail =
          ((hw12_rec1_mdl_DW.TransportDelay_IWORK.Tail <
            (hw12_rec1_mdl_DW.TransportDelay_IWORK.CircularBufSize-1)) ?
           (hw12_rec1_mdl_DW.TransportDelay_IWORK.Tail+1) : 0);
      }

      (*tBuffer)[hw12_rec1_mdl_DW.TransportDelay_IWORK.Head] = simTime;
      (*uBuffer)[hw12_rec1_mdl_DW.TransportDelay_IWORK.Head] = rtb_Gain;
    }
  }                                    /* end MajorTimeStep */

  if (rtmIsMajorTimeStep(hw12_rec1_mdl_M)) {
    /* signal main to stop simulation */
    {                                  /* Sample time: [0.0s, 0.0s] */
      if ((rtmGetTFinal(hw12_rec1_mdl_M)!=-1) &&
          !((rtmGetTFinal(hw12_rec1_mdl_M)-(((hw12_rec1_mdl_M->Timing.clockTick1
               +hw12_rec1_mdl_M->Timing.clockTickH1* 4294967296.0)) * 0.8)) >
            (((hw12_rec1_mdl_M->Timing.clockTick1+
               hw12_rec1_mdl_M->Timing.clockTickH1* 4294967296.0)) * 0.8) *
            (DBL_EPSILON))) {
        rtmSetErrorStatus(hw12_rec1_mdl_M, "Simulation finished");
      }
    }

    rt_ertODEUpdateContinuousStates(&hw12_rec1_mdl_M->solverInfo);

    /* Update absolute time for base rate */
    /* The "clockTick0" counts the number of times the code of this task has
     * been executed. The absolute time is the multiplication of "clockTick0"
     * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
     * overflow during the application lifespan selected.
     * Timer of this task consists of two 32 bit unsigned integers.
     * The two integers represent the low bits Timing.clockTick0 and the high bits
     * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
     */
    if (!(++hw12_rec1_mdl_M->Timing.clockTick0)) {
      ++hw12_rec1_mdl_M->Timing.clockTickH0;
    }

    hw12_rec1_mdl_M->Timing.t[0] = rtsiGetSolverStopTime
      (&hw12_rec1_mdl_M->solverInfo);

    {
      /* Update absolute timer for sample time: [0.8s, 0.0s] */
      /* The "clockTick1" counts the number of times the code of this task has
       * been executed. The resolution of this integer timer is 0.8, which is the step size
       * of the task. Size of "clockTick1" ensures timer will not overflow during the
       * application lifespan selected.
       * Timer of this task consists of two 32 bit unsigned integers.
       * The two integers represent the low bits Timing.clockTick1 and the high bits
       * Timing.clockTickH1. When the low bit overflows to 0, the high bits increment.
       */
      hw12_rec1_mdl_M->Timing.clockTick1++;
      if (!hw12_rec1_mdl_M->Timing.clockTick1) {
        hw12_rec1_mdl_M->Timing.clockTickH1++;
      }
    }
  }                                    /* end MajorTimeStep */
}

/* Derivatives for root system: '<Root>' */
void hw12_rec1_mdl_derivatives(void)
{
  XDot_hw12_rec1_mdl_T *_rtXdot;
  _rtXdot = ((XDot_hw12_rec1_mdl_T *) hw12_rec1_mdl_M->derivs);

  /* Derivatives for TransferFcn: '<Root>/Transfer Fcn' */
  _rtXdot->TransferFcn_CSTATE[0] = 0.0;
  _rtXdot->TransferFcn_CSTATE[0] += hw12_rec1_mdl_P.TransferFcn_A[0] *
    hw12_rec1_mdl_X.TransferFcn_CSTATE[0];
  _rtXdot->TransferFcn_CSTATE[1] = 0.0;
  _rtXdot->TransferFcn_CSTATE[0] += hw12_rec1_mdl_P.TransferFcn_A[1] *
    hw12_rec1_mdl_X.TransferFcn_CSTATE[1];
  _rtXdot->TransferFcn_CSTATE[1] += hw12_rec1_mdl_X.TransferFcn_CSTATE[0];
  _rtXdot->TransferFcn_CSTATE[0] += hw12_rec1_mdl_B.TransportDelay;
}

/* Model initialize function */
void hw12_rec1_mdl_initialize(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((void *)hw12_rec1_mdl_M, 0,
                sizeof(RT_MODEL_hw12_rec1_mdl_T));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&hw12_rec1_mdl_M->solverInfo,
                          &hw12_rec1_mdl_M->Timing.simTimeStep);
    rtsiSetTPtr(&hw12_rec1_mdl_M->solverInfo, &rtmGetTPtr(hw12_rec1_mdl_M));
    rtsiSetStepSizePtr(&hw12_rec1_mdl_M->solverInfo,
                       &hw12_rec1_mdl_M->Timing.stepSize0);
    rtsiSetdXPtr(&hw12_rec1_mdl_M->solverInfo, &hw12_rec1_mdl_M->derivs);
    rtsiSetContStatesPtr(&hw12_rec1_mdl_M->solverInfo, (real_T **)
                         &hw12_rec1_mdl_M->contStates);
    rtsiSetNumContStatesPtr(&hw12_rec1_mdl_M->solverInfo,
      &hw12_rec1_mdl_M->Sizes.numContStates);
    rtsiSetNumPeriodicContStatesPtr(&hw12_rec1_mdl_M->solverInfo,
      &hw12_rec1_mdl_M->Sizes.numPeriodicContStates);
    rtsiSetPeriodicContStateIndicesPtr(&hw12_rec1_mdl_M->solverInfo,
      &hw12_rec1_mdl_M->periodicContStateIndices);
    rtsiSetPeriodicContStateRangesPtr(&hw12_rec1_mdl_M->solverInfo,
      &hw12_rec1_mdl_M->periodicContStateRanges);
    rtsiSetErrorStatusPtr(&hw12_rec1_mdl_M->solverInfo, (&rtmGetErrorStatus
      (hw12_rec1_mdl_M)));
    rtsiSetRTModelPtr(&hw12_rec1_mdl_M->solverInfo, hw12_rec1_mdl_M);
  }

  rtsiSetSimTimeStep(&hw12_rec1_mdl_M->solverInfo, MAJOR_TIME_STEP);
  hw12_rec1_mdl_M->intgData.y = hw12_rec1_mdl_M->odeY;
  hw12_rec1_mdl_M->intgData.f[0] = hw12_rec1_mdl_M->odeF[0];
  hw12_rec1_mdl_M->intgData.f[1] = hw12_rec1_mdl_M->odeF[1];
  hw12_rec1_mdl_M->intgData.f[2] = hw12_rec1_mdl_M->odeF[2];
  hw12_rec1_mdl_M->contStates = ((X_hw12_rec1_mdl_T *) &hw12_rec1_mdl_X);
  rtsiSetSolverData(&hw12_rec1_mdl_M->solverInfo, (void *)
                    &hw12_rec1_mdl_M->intgData);
  rtsiSetSolverName(&hw12_rec1_mdl_M->solverInfo,"ode3");
  rtmSetTPtr(hw12_rec1_mdl_M, &hw12_rec1_mdl_M->Timing.tArray[0]);
  rtmSetTFinal(hw12_rec1_mdl_M, 40.0);
  hw12_rec1_mdl_M->Timing.stepSize0 = 0.8;

  /* Setup for data logging */
  {
    static RTWLogInfo rt_DataLoggingInfo;
    rt_DataLoggingInfo.loggingInterval = NULL;
    hw12_rec1_mdl_M->rtwLogInfo = &rt_DataLoggingInfo;
  }

  /* Setup for data logging */
  {
    rtliSetLogXSignalInfo(hw12_rec1_mdl_M->rtwLogInfo, (NULL));
    rtliSetLogXSignalPtrs(hw12_rec1_mdl_M->rtwLogInfo, (NULL));
    rtliSetLogT(hw12_rec1_mdl_M->rtwLogInfo, "tout");
    rtliSetLogX(hw12_rec1_mdl_M->rtwLogInfo, "");
    rtliSetLogXFinal(hw12_rec1_mdl_M->rtwLogInfo, "");
    rtliSetLogVarNameModifier(hw12_rec1_mdl_M->rtwLogInfo, "rt_");
    rtliSetLogFormat(hw12_rec1_mdl_M->rtwLogInfo, 0);
    rtliSetLogMaxRows(hw12_rec1_mdl_M->rtwLogInfo, 1000);
    rtliSetLogDecimation(hw12_rec1_mdl_M->rtwLogInfo, 1);
    rtliSetLogY(hw12_rec1_mdl_M->rtwLogInfo, "");
    rtliSetLogYSignalInfo(hw12_rec1_mdl_M->rtwLogInfo, (NULL));
    rtliSetLogYSignalPtrs(hw12_rec1_mdl_M->rtwLogInfo, (NULL));
  }

  /* block I/O */
  (void) memset(((void *) &hw12_rec1_mdl_B), 0,
                sizeof(B_hw12_rec1_mdl_T));

  /* states (continuous) */
  {
    (void) memset((void *)&hw12_rec1_mdl_X, 0,
                  sizeof(X_hw12_rec1_mdl_T));
  }

  /* states (dwork) */
  (void) memset((void *)&hw12_rec1_mdl_DW, 0,
                sizeof(DW_hw12_rec1_mdl_T));

  /* Matfile logging */
  rt_StartDataLoggingWithStartTime(hw12_rec1_mdl_M->rtwLogInfo, 0.0,
    rtmGetTFinal(hw12_rec1_mdl_M), hw12_rec1_mdl_M->Timing.stepSize0,
    (&rtmGetErrorStatus(hw12_rec1_mdl_M)));

  /* Start for TransportDelay: '<Root>/Transport Delay' */
  {
    real_T *pBuffer = &hw12_rec1_mdl_DW.TransportDelay_RWORK.TUbufferArea[0];
    hw12_rec1_mdl_DW.TransportDelay_IWORK.Tail = 0;
    hw12_rec1_mdl_DW.TransportDelay_IWORK.Head = 0;
    hw12_rec1_mdl_DW.TransportDelay_IWORK.Last = 0;
    hw12_rec1_mdl_DW.TransportDelay_IWORK.CircularBufSize = 1024;
    pBuffer[0] = hw12_rec1_mdl_P.TransportDelay_InitOutput;
    pBuffer[1024] = hw12_rec1_mdl_M->Timing.t[0];
    hw12_rec1_mdl_DW.TransportDelay_PWORK.TUbufferPtrs[0] = (void *) &pBuffer[0];
    hw12_rec1_mdl_DW.TransportDelay_PWORK.TUbufferPtrs[1] = (void *) &pBuffer
      [1024];
  }

  /* InitializeConditions for TransferFcn: '<Root>/Transfer Fcn' */
  hw12_rec1_mdl_X.TransferFcn_CSTATE[0] = 0.0;
  hw12_rec1_mdl_X.TransferFcn_CSTATE[1] = 0.0;
}

/* Model terminate function */
void hw12_rec1_mdl_terminate(void)
{
  /* (no terminate code required) */
}
