//+------------------------------------------------------------------+
//|                                                   TestingDll.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#import "DLLSample.dll"
int    GetIntValue(int);
double GetDoubleValue(double);
string GetStringValue(string);
#import

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
    double ret,some_value=10.5;
    string sret;
    int    cnt;
    //--- simple dll-functions call
    cnt=GetIntValue(int(some_value));
    Print("Returned value is ",cnt);

    ret=GetDoubleValue(some_value);
    Print("Returned value is ",ret);

    sret=GetStringValue("some string");
    Print("Returned value is ",sret);
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
