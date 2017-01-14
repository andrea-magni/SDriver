(*
  Copyright 2016, Andrea Magni
  https://github.com/andrea-magni/SDriver
*)
unit SDriver.BufferedExecutor;

interface

uses
  Classes, SysUtils, System.Generics.Collections
, SDriver.Interfaces, SDriver.Executor
;

type
  TBufferedExecutor = class(TInterfacedObject, IMessageBuffer)
  private
    FStack: TStack<IMessage>;
    FExecutor: IExecutor;
  public
    constructor Create(const ABaseURL: string; const AAsync: Boolean = True); virtual;
    destructor Destroy; override;

    // IMessageBuffer
    procedure Push(const AMessage: IMessage);
    function Pop: IMessage;
    function MessageCount: Integer;
    procedure Flush;
  end;

implementation

{ TBufferedExecutor }


procedure TBufferedExecutor.Flush;
begin
  while MessageCount > 0 do
    FExecutor.Send(Pop);
end;

function TBufferedExecutor.MessageCount: Integer;
begin
  Result := FStack.Count;
end;

function TBufferedExecutor.Pop: IMessage;
begin
  Result := FStack.Pop;
end;

procedure TBufferedExecutor.Push(const AMessage: IMessage);
begin
  FStack.Push(AMessage);
end;

constructor TBufferedExecutor.Create(const ABaseURL: string; const AAsync: Boolean);
begin
  inherited Create;
  FStack := TStack<IMessage>.Create;
  FExecutor := TExecutor.Create(ABaseURL, AAsync);
end;

destructor TBufferedExecutor.Destroy;
begin
  FreeAndNil(FStack);
  FExecutor := nil;
  inherited;
end;

end.
