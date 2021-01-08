//----------------------------------------------------------------------------
#ifndef reportH
#define reportH
//----------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\QuickRpt.hpp>
#include <vcl\QRCtrls.hpp>
#include <ExtCtrls.hpp>
//----------------------------------------------------------------------------
class TQuickReport1 : public TQuickRep
{
__published:
  TQRBand *TitleBand1;
  TQRBand *ColumnHeaderBand1;
  TQRBand *DetailBand1;
private:
public:
   __fastcall TQuickReport1::TQuickReport1(TComponent* Owner);
};
//----------------------------------------------------------------------------
extern TQuickReport1 *QuickReport1;
//----------------------------------------------------------------------------
#endif