unit RegularPolygon;

interface

uses
  System.SysUtils, System.Classes, System.Types, System.Math,
  FMX.Types, FMX.Controls, FMX.Objects, FMX.Graphics;

type
  TRegularPolygon = class(TShape)
  private
    FNumberOfSides: Integer;
    FPath: TPathData;
    procedure SetNumberOfSides(const Value: Integer);
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
    procedure CreatePath;
    procedure Paint; override;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function PointInObject(X, Y: Single): Boolean; override;
  published
    { Published-Deklarationen }
    property NumberOfSides: Integer read FNumberOfSides write SetNumberOfSides;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TRegularPolygon]);
end;

{ TRegularPolygon }

constructor TRegularPolygon.Create(AOwner: TComponent);
begin
  inherited;
  FNumberOfSides := 3;
  FPath := TPathData.Create;
end;

procedure TRegularPolygon.CreatePath;
  procedure GoToAVertex(n: Integer; Angle, CircumRadius: Double;
    IsLineTo: Boolean = True);
  var
    NewLocation: TPointF;
  begin
    NewLocation.X := Width  / 2 + Cos(n * Angle) * CircumRadius;
    NewLocation.Y := Height / 2 - Sin(n * Angle) * CircumRadius;

    if IsLineTo then
      FPath.LineTo(NewLocation)
    else
      FPath.MoveTo(NewLocation);
  end;
var
  i: Integer;
  Angle, CircumRadius: Double;
begin
  Angle        := 2 * PI / FNumberOfSides;
  CircumRadius := Min(ShapeRect.Width / 2, ShapeRect.Height / 2);

  // Create a new Path
  FPath.Clear;

  // MoveTo the first point
  GoToAVertex(0, Angle, CircumRadius, False);

  // LineTo each Vertex
  for i := 1 to FNumberOfSides do
    GoToAVertex(i, Angle, CircumRadius);

  FPath.ClosePath;

end;

destructor TRegularPolygon.Destroy;
begin
  FreeAndNil(FPath);
  inherited;
end;

procedure TRegularPolygon.Paint;
begin
  CreatePath;
  Canvas.FillPath(FPath, AbsoluteOpacity);
  Canvas.DrawPath(FPath, AbsoluteOpacity);
end;

function TRegularPolygon.PointInObject(X, Y: Single): Boolean;
begin
  CreatePath;
  Result := Canvas.PtInPath(AbsoluteToLocal(PointF(X, Y)), FPath);
end;

procedure TRegularPolygon.SetNumberOfSides(const Value: Integer);
begin
  if (FNumberOfSides <> Value) and (Value >= 3) then
  begin
    FNumberOfSides := Value;
    Repaint;
  end;
end;

end.
