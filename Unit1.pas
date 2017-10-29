unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Gestures;

type
  TForm1 = class(TForm)
    Image1: TImage;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    OpenDialog1: TOpenDialog;
    SpeedButton2: TSpeedButton;
    procedure Image1Gesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure Image1Paint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure Image1Tap(Sender: TObject; const Point: TPointF);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { private êÈåæ }
    tap: integer;
    dis: integer;
    ang: Double;
    dot1, dot2, pan: TPointF;
  public
    { public êÈåæ }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Image1Gesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var
  i, j: Single;
begin
  case EventInfo.GestureID of
    igiLongTap:
      begin
        SpeedButton1Click(Sender);
        tap := 0;
      end;
    igiZoom:
      if tap = 2 then
      begin
        with EventInfo do
        begin
          i := (Distance - dis) * cos(ang) / 2;
          j := (Distance - dis) * sin(ang) / 2;
          dis := Distance;
          if Flags = [TInteractiveGestureFlag.gfBegin] then
            Exit;
        end;
        dot1.X := dot1.X - i;
        dot2.X := dot2.X + i;
        dot1.Y := dot1.Y - j;
        dot2.Y := dot2.Y + j;
        Image1.Repaint;
      end;
    igiRotate:
      ang := EventInfo.Angle;
    igiPressAndTap:
      with EventInfo do
        ang := arctan((Location.Y - TapLocation.Y) /
          (Location.X - TapLocation.X));
    igiPan:
      begin
        i := EventInfo.Location.X - pan.X;
        j := EventInfo.Location.Y - pan.Y;
        pan := EventInfo.Location;
        if EventInfo.Flags = [TInteractiveGestureFlag.gfBegin] then
          Exit;
        dot1.X := dot1.X + i;
        dot2.X := dot2.X + i;
        dot1.Y := dot1.Y + j;
        dot2.Y := dot2.Y + j;
        Image1.Repaint;
      end;
  end;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  // Image1Tap(Sender, PointF(X, Y));
end;

procedure TForm1.Image1Paint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  case tap of
    1:
      Image1.Canvas.FillEllipse(RectF(dot1.X - 5, dot1.Y - 5, dot1.X + 5,
        dot1.Y + 5), 1);
    2:
      Image1.Canvas.FillRect(RectF(dot1.X, dot1.Y, dot2.X, dot2.Y), 0,
        0, [], 0.5);
  end;
end;

procedure TForm1.Image1Tap(Sender: TObject; const Point: TPointF);
var
  i, j: Single;
begin
  case tap of
    0:
      dot1 := Point;
    1:
      begin
        dot2 := Point;
        i := dot1.X - dot2.X;
        j := dot1.Y - dot2.Y;
        if (i < 20) and (i > -20) and (j < 20) and (j > -20) then
        begin
          tap := 0;
          dot1 := dot2;
        end
        else
          SpeedButton2.Enabled := true;
      end
  else
    tap := 0;
    SpeedButton2.Enabled := false;
    dot1 := Point;
  end;
  inc(tap);
  Image1.Repaint;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin;

  ;
end;

end.
