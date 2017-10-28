unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Gestures;

type
  TForm1 = class(TForm)
    Image1: TImage;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    OpenDialog1: TOpenDialog;
    SpeedButton2: TSpeedButton;
    GestureManager1: TGestureManager;
    procedure Image1Gesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure Image1Paint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { private êÈåæ }
    tap: integer;
    dot1, dot2: TPointF;
  public
    { public êÈåæ }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Image1Gesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  case Tag of
  0:
    dot1 := EventInfo.TapLocation;
  1:
  begin
    dot2 := EventInfo.TapLocation;
    SpeedButton2.Enabled := true;
  end
  else
    tap := 0;
    SpeedButton2.Enabled := false;
    dot1 := EventInfo.TapLocation;
  end;
  inc(tap);
end;

procedure TForm1.Image1Paint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  case tap of
  1:
    Image1.Canvas.DrawEllipse(RectF(dot1.X-1,dot1.Y-1,dot1.X+1,dot1.Y+1),1);
  2:
    Image1.Canvas.DrawRect(RectF(dot1.X,dot2.Y,dot2.X,dot2.Y),0,0,[],0.5);
  end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if OpenDialog1.Execute = true then
    Image1.Bitmap.LoadFromFile(OpenDialog1.FileName);
end;

end.
