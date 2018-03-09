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
    ang: Single;
    dot1, dot2, pan: TPointF;
    state: integer;
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
  procedure resize_x;
  begin
    if dot1.X < dot2.X then
    begin
      dot1.X := dot1.X - i;
      dot2.X := dot2.X + i;
    end
    else
    begin
      dot1.X := dot1.X + i;
      dot2.X := dot2.X - i;
    end;
  end;
  procedure resize_y;
  begin
    if dot1.Y < dot2.Y then
    begin
      dot1.Y := dot1.Y - j;
      dot2.Y := dot2.Y + j;
    end
    else
    begin
      dot1.Y := dot1.Y + i;
      dot2.Y := dot2.Y - i;
    end;
  end;

begin
  case EventInfo.GestureID of
    igiDoubleTap:
      begin
        SpeedButton1Click(Sender);
        tap := 0;
      end;
    igiRotate:
      with EventInfo do
      begin
        ang := ang - Angle;
        if ang < 0 then
          ang := ang + pi;
        if ang < pi / 6 then
          state := 1
        else if ang < pi / 3 then
          state := 2
        else if ang < 2 * pi / 3 then
          state := 3
        else if ang < 5 * pi / 6 then
          state := 2
        else
          state := 1
      end;
    igiZoom:
      if tap = 2 then
      begin
        with EventInfo do
        begin
          i := (Distance - dis) * cos(Angle) / 2;
          j := (Distance - dis) * sin(Angle) / 2;
          dis := Distance;
        end;
        case state of
          0:
            begin
              ang := EventInfo.Angle;
              state := 1;
            end;
          1:
            resize_x;
          2:
            begin
              resize_x;
              resize_y;
            end;
          3:
            resize_y;
        end;
        Image1.Repaint;
      end;
    igiPan:
      begin
        i := EventInfo.Location.X - pan.X;
        j := EventInfo.Location.Y - pan.Y;
        pan := EventInfo.Location;
        if TInteractiveGestureFlag.gfBegin in EventInfo.Flags then
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
{$IFDEF MSWINDOWS}
  Image1Tap(Sender, PointF(X, Y));
{$ENDIF}
end;

procedure TForm1.Image1Paint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
var
  s: Single;
begin
  case tap of
    1:
      with Image1.Canvas do
      begin
        Fill.Color := TAlphaColors.Red;
        FillEllipse(RectF(dot1.X - 5, dot1.Y - 5, dot1.X + 5, dot1.Y + 5), 1);
        Fill.Color := TAlphaColors.White;
        FillEllipse(RectF(dot1.X - 4, dot1.Y - 4, dot1.X + 4, dot1.Y + 4), 1);
      end;
    2:
      with Image1.Canvas do
      begin
        DrawLine(dot1, dot2, 1);
        DrawLine(PointF(dot2.X, dot1.Y), PointF(dot1.X, dot2.Y), 1);
        Fill.Color := TAlphaColors.White;
        FillRect(RectF(dot1.X, dot1.Y, dot2.X, dot2.Y), 0, 0, [], 0.5);
        Fill.Color := TAlphaColors.Green;
        FillRect(RectF(dot1.X - 2, dot1.Y - 2, dot1.X + 2, dot1.Y + 2), 0,
          0, [], 1);
        FillRect(RectF(dot2.X - 2, dot1.Y - 2, dot2.X + 2, dot1.Y + 2), 0,
          0, [], 1);
        FillRect(RectF(dot1.X - 2, dot2.Y - 2, dot1.X + 2, dot2.Y + 2), 0,
          0, [], 1);
        FillRect(RectF(dot2.X - 2, dot2.Y - 2, dot2.X + 2, dot2.Y + 2), 0,
          0, [], 1);
        s := (dot1.X + dot2.X) / 2;
        FillRect(RectF(s - 2, dot1.Y - 2, s + 2, dot1.Y + 2), 0, 0, [], 1);
        FillRect(RectF(s - 2, dot2.Y - 2, s + 2, dot2.Y + 2), 0, 0, [], 1);
        s := (dot1.Y + dot2.Y) / 2;
        FillRect(RectF(dot1.X - 2, s - 2, dot1.X + 2, s + 2), 0, 0, [], 1);
        FillRect(RectF(dot2.X - 2, s - 2, dot2.X + 2, s + 2), 0, 0, [], 1);
        Fill.Color := TAlphaColors.Yellow;
        case state of
          1:
            begin
              s := (dot1.Y + dot2.Y) / 2;
              FillRect(RectF(dot1.X - 2, s - 2, dot1.X + 2, s + 2), 0,
                0, [], 1);
              FillRect(RectF(dot2.X - 2, s - 2, dot2.X + 2, s + 2), 0,
                0, [], 1);
            end;
          2:
            begin
              FillRect(RectF(dot1.X - 2, dot1.Y - 2, dot1.X + 2, dot1.Y + 2), 0,
                0, [], 1);
              FillRect(RectF(dot1.X - 2, dot2.Y - 2, dot1.X + 2, dot2.Y + 2), 0,
                0, [], 1);
              FillRect(RectF(dot2.X - 2, dot1.Y - 2, dot2.X + 2, dot1.Y + 2), 0,
                0, [], 1);
              FillRect(RectF(dot2.X - 2, dot2.Y - 2, dot2.X + 2, dot2.Y + 2), 0,
                0, [], 1);
            end;
          3:
            begin
              s := (dot1.X + dot2.X) / 2;
              FillRect(RectF(s - 2, dot1.Y - 2, s + 2, dot1.Y + 2), 0,
                0, [], 1);
              FillRect(RectF(s - 2, dot2.Y - 2, s + 2, dot2.Y + 2), 0,
                0, [], 1);
            end;
        end;
      end;
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
        state := 0;
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
