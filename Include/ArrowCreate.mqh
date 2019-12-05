//+------------------------------------------------------------------+
//|                                                  ArrowCreate.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| Create the arrow                                                 |
//+------------------------------------------------------------------+


bool ArrowCreate(string name, datetime time, double price, color clr, double size, int type){

//--- create an arrow
	/*if (!ObjectCreate(NULL,name,OBJ_ARROW,0,time,price)){

		Print(__FUNCTION__,
		    ": failed to create an arrow! Error code = ",GetLastError());
		return(false);
	}*/
	int anchor;

	if (type == 225) {
		anchor = ANCHOR_BOTTOM;
	} else {
		anchor = ANCHOR_TOP;
	}

	ObjectCreate(NULL,name,OBJ_ARROW,0,time,price);

	ObjectSetInteger(NULL,name,OBJPROP_ARROWCODE,type);
	ObjectSetInteger(NULL,name,OBJPROP_ANCHOR,ANCHOR_BOTTOM);
	ObjectSetInteger(NULL,name,OBJPROP_COLOR,clr);
	ObjectSetInteger(NULL,name,OBJPROP_STYLE,STYLE_SOLID);
	ObjectSetInteger(NULL,name,OBJPROP_WIDTH,size);
	ObjectSetInteger(NULL,name,OBJPROP_BACK,true);
	ObjectSetInteger(NULL,name,OBJPROP_SELECTABLE,false);
	ObjectSetInteger(NULL,name,OBJPROP_SELECTED,false);
	ObjectSetInteger(NULL,name,OBJPROP_HIDDEN,true);
	ObjectSetInteger(NULL,name,OBJPROP_ZORDER,0);
//--- successful execution
   return(true);
}
