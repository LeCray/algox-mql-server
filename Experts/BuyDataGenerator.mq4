//+------------------------------------------------------------------+
//|                                                DataGenerator.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <ArrowCreate.mqh>

int handle;
//--- parameters for writing data to file
input string    InpFileName = "BuyData.csv";      // File name
input string    InpDirectoryName = "Data";     // Folder name
input string    symbol = "EURUSD";
input int       timeFrame = 5;

double stoplossVar = 10;
double lotSize = 1;

datetime time_array[];
double open_price[];
double close_price[];
double stochastics[];
double volume[];
double outcome[];
double bigMovingAvg[];
double smallMovingAvg[];

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
/*
    for (int i=0; i<ArraySize(close_price); i++) {
        Print("CLosing Prices: ", close_price[i]);
    }
*/

    //Open file
    int file_handle = FileOpen(InpDirectoryName+"//"+InpFileName,FILE_CSV|FILE_READ|FILE_WRITE,',');

    if (file_handle != INVALID_HANDLE) {
        PrintFormat("%s file is available for writing", InpFileName);
        //--- first, write the number of signals
        //FileWrite(file_handle, "OPENING PRICE", "CLOSING PRICE", "STOCHASTICS", "VOLUME", "OUTCOME");
        //--- write the data to the file
        for (int i=0; i < ArraySize(outcome); i++) {
            //Print("Data being written: ", time_array[i],':', close_price[i],':', stochastics[i],':', volume[i]);
            FileWrite(file_handle, open_price[i], close_price[i], stochastics[i], volume[i], outcome[i]);
        }
        //--- close the file
        FileClose(file_handle);
        PrintFormat("Data is written, %s file is closed", InpFileName);
    } else {
        PrintFormat("Failed to open %s file, Error code = %d", InpFileName, GetLastError());
    }

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

    //BUY
    if(OrdersTotal() == 0) { //Making sure only 1 order is open at a time

        ArrayResize(time_array, ArraySize(time_array) + 1);
        time_array[ArraySize(time_array) - 1] = iTime(NULL,PERIOD_M5,0);

        ArrayResize(open_price, ArraySize(open_price) + 1);
        open_price[ArraySize(open_price) - 1] = iOpen(NULL,PERIOD_M5,0);

        ArrayResize(close_price, ArraySize(close_price) + 1);
        close_price[ArraySize(close_price) - 1] = iClose(NULL,PERIOD_M5,0);

        ArrayResize(stochastics, ArraySize(stochastics) + 1);
        stochastics[ArraySize(stochastics) - 1] = iStochastic(NULL,PERIOD_M5,5,3,3,MODE_SMA,0,MODE_MAIN,0);

        ArrayResize(volume, ArraySize(volume) + 1);
        volume[ArraySize(volume) - 1] = iVolume(NULL,PERIOD_M5,0);

        //Selecting the order to find OrderProfit() of.
        //OrderSelect() returns true if order is found.
        if (OrderSelect(OrdersHistoryTotal() - 1, SELECT_BY_POS, MODE_HISTORY)) {
            ArrayResize(outcome, ArraySize(outcome) + 1);

            if (OrderProfit() > 0) {
                outcome[ArraySize(outcome) - 1] = 1;
            } else {
                outcome[ArraySize(outcome) - 1] = 0;
            }
            Print("Last Outcome: ", outcome[ArraySize(outcome) - 1])  ;
        } else {Print("No Cigar");}



/*
        ArrayResize(bigMovingAvg, ArraySize(bigMovingAvg) + 1);
        bigMovingAvg[ArraySize(bigMovingAvg) - 1] = iMA(NULL,0,13,8,MODE_EMA,PRICE_MEDIAN,i);

        ArrayResize(smallMovingAvg, ArraySize(smallMovingAvg) + 1);
        smallMovingAvg[ArraySize(smallMovingAvg) - 1] = iMA(NULL,0,13,8,MODE_EMA,PRICE_MEDIAN,i);
*/


        //Print("time_array: ", time_array[ArraySize(time_array) - 1]);

        //PRINT ARROW
        string dojiArrow = StringConcatenate("dojiArrow", High[1]);
        datetime time = Time[1];
        double price2 = Low[1];
        color clr = clrGreen;
        int size = 1;
        int type = 225;
        ArrowCreate(dojiArrow, time, price2, clr, size, type); //This function is defined in ArrowCreate.mqh

        double minstoplevel = MarketInfo(0, MODE_STOPLEVEL);
        double risk = (minstoplevel + stoplossVar)*Point(); //Turning pips into point size i.e 2 pips = 0.0002 on price axis
        double reward = risk*8;

        //Rounding off SL and TP to charts required degree of accuracy
        double stoploss = NormalizeDouble(Bid - risk, Digits());
        double takeprofit = NormalizeDouble(Bid + reward, Digits());

        //Print("Current High:", High[0]," ","Ask:", Ask," ", "Buy:",Bid);
        //Print("Risk=",risk,"; ","Reward=",reward,"; ","SL=",stoploss,"; ","TP=",takeprofit, "; ","Lots=",lotSize);
        RefreshRates();
        int ticket = OrderSend(Symbol(), OP_BUY, lotSize, Ask, 3, stoploss, takeprofit,"My first order",0, 0, clrGreen);

        if(ticket < 0) {
            Alert("OrderSend failed with error #",GetLastError());
        } else {
            Print("OrderSend placed successfully");
        }

    } //else {Print("Still in a position!");}
/*
    //SELL
    if(OrdersTotal() == 0) { //Making sure only 1 order is open at a time
        string dojiArrow = StringConcatenate("dojiArrow",High[1]);
        datetime time = Time[1];
        double price2 = High[1];
        color clr = clrRed;
        int size = 1;
        int type = 226;
        ArrowCreate(dojiArrow, time, price2, clr, size, type); //This function is defined in ArrowCreate.mqh


        double minstoplevel = MarketInfo(0,MODE_STOPLEVEL);
        double risk = minstoplevel*Point(); //Turning pips into point size i.e 2 pips = 0.0002 on price axis
        double reward = risk*3;

        //Rounding off SL and TP to charts required degree of accuracy
        double stoploss = NormalizeDouble(Ask + risk, Digits());
        double takeprofit = NormalizeDouble(Ask - reward, Digits());

        //Print("Current High:", High[0]," ","Ask:", Ask," ", "Buy:",Bid);
        //Print("Risk=",risk,"; ","Reward=",reward,"; ","SL=",stoploss,"; ",takeprofit, "; ","Lots=",lotSize);

        RefreshRates();
        int ticket = OrderSend(Symbol(), OP_SELL, lotSize, Bid, 3, stoploss, takeprofit,"Another one",0, 0, clrRed);

        if(ticket < 0) {
            Alert("OrderSend failed with error #",GetLastError());
        } else {
            Print("OrderSend placed successfully");
        }

    } else {Print("Still in a position!");}
*/
  }
//+------------------------------------------------------------------+
