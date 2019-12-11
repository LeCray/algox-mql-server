//+------------------------------------------------------------------+
//|                                                     BuyNNDLL.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#import "BuyNN.dll"
int    GetIntValue(const int ipar);
int    RunPythonFunc(int argc, char &argv[]);
int Test(
    const double open,
    const double close,
    const double stoch,
    const double vol
);
#import
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
    double ret,some_value = 10.5;
    string sret;
    int    cnt;
    //--- simple dll-functions call
    //cnt = GetIntValue(int(some_value));

    cnt = Test(100,2,5,6);
    Print("Returned value is ",cnt);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

  }
//+------------------------------------------------------------------+
