#pragma once
#define MT4_EXPFUNC __declspec(dllexport)

extern "C" MT4_EXPFUNC int __stdcall Test(
    const double open,
    const double close,
    const double stoch,
    const double vol
);
extern "C" MT4_EXPFUNC int __stdcall GetIntValue(const int ipar);
extern "C" MT4_EXPFUNC int __stdcall RunPythonFunc(int argc, char* argv[]);


