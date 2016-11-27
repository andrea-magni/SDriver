(*
  Copyright 2016, Andrea Magni
  https://github.com/andrea-magni/SlackDriver
*)
unit SlackDriver.Executor;

interface

uses
  Classes, SysUtils
, System.Threading
, System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent
, SlackDriver.Interfaces
;

type
  TNetHTTPRequestEx = class(TNetHTTPRequest)
  public
    TheMessage: IMessage;
    OnSuccess: TOnSuccessProc;
    OnError: TOnErrorProc;
    procedure InternalAfterSend(const AResponse: IHTTPResponse); virtual;
  end;

  TExecutor = class(TInterfacedObject, IExecutor)
  private
    FBaseURL: string;
    FClient: TNetHTTPClient;
    FRequest: TNetHTTPRequestEx;
    FAsynchronous: Boolean;
  protected
    procedure SetupNetComponents(AMessage: IMessage; const AOnSuccess: TOnSuccessProc;
      const AOnError: TOnErrorProc); virtual;
    procedure FinalizeNetComponents; virtual;

    procedure InternalSend(); virtual;

    // Beware: this method will be called in the main thread (there is a Synchronize in TNetHTTPRequest.DoOnRequestCompleted)
    procedure RequestCompletedHandler(const Sender: TObject; const AResponse: IHTTPResponse); virtual;
  public
    constructor Create(const ABaseURL: string = ''; const AAsync: Boolean = True); virtual;
    destructor Destroy; override;

    // IExecutor
    procedure Send(AMessage: IMessage; const AOnSuccess: TProc<IMessage> = nil;
      const AOnError: TProc<IMessage, Integer, string, string> = nil); virtual;

    property BaseURL: string read FBaseURL write FBaseURL;
    property Asynchronous: Boolean read FAsynchronous write FAsynchronous;
  end;

  TIncomingWebHook = class(TExecutor)
  public

  end;

implementation

uses
  System.JSON
;

{ TExecutor }

constructor TExecutor.Create(const ABaseURL: string; const AAsync: Boolean);
begin
  inherited Create;
  FBaseURL := ABaseURL;
  FAsynchronous := AAsync;
end;

destructor TExecutor.Destroy;
begin
  inherited;
end;

procedure TExecutor.FinalizeNetComponents;
begin
  FreeAndNil(FRequest);
  FreeAndNil(FClient);
end;

procedure TExecutor.InternalSend();
var
  LStream: TBytesStream;
  LJSON: TJSONObject;
  LResponse: IHTTPResponse;
begin
  LJSON := FRequest.TheMessage.ToJSON;
  try
    LStream := TBytesStream.Create(TEncoding.UTF8.GetBytes(LJSON.ToJSON));
    try
      FRequest.Asynchronous := Asynchronous;
      FRequest.OnRequestCompleted := RequestCompletedHandler;

      LResponse := FRequest.Post(FBaseURL, LStream);
    finally
      if not Asynchronous then
        LStream.Free;
    end;
  finally
    LJSON.Free;
  end;
end;

procedure TExecutor.RequestCompletedHandler(const Sender: TObject;
  const AResponse: IHTTPResponse);
begin
  (Sender as TNetHTTPRequestEx).InternalAfterSend(AResponse);
end;

procedure TExecutor.Send(AMessage: IMessage; const AOnSuccess: TOnSuccessProc;
  const AOnError: TOnErrorProc);
begin
  SetupNetComponents(AMessage, AOnSuccess, AOnError);
  try
    InternalSend();
  finally
    if not Asynchronous then
      FinalizeNetComponents;
  end;
end;

procedure TExecutor.SetupNetComponents(AMessage: IMessage; const AOnSuccess: TOnSuccessProc;
  const AOnError: TOnErrorProc);
begin
  FClient := TNetHTTPClient.Create(nil);
  try
    FRequest := TNetHTTPRequestEx.Create(nil);
    try
      FRequest.Client := FClient;
      FRequest.TheMessage := AMessage;
      FRequest.OnSuccess := AOnSuccess;
      FRequest.OnError := AOnError;
    except
      FreeAndNil(FRequest);
      raise;
    end;
  except
    FreeAndNil(FClient);
    raise;
  end;
end;

{ TNetHTTPRequestEx }

procedure TNetHTTPRequestEx.InternalAfterSend(const AResponse: IHTTPResponse);
var
  LSuccess: Boolean;
begin
  LSuccess := Assigned(AResponse) and (AResponse.StatusCode = 200);
  if LSuccess then
  begin
    if Assigned(OnSuccess) then
      OnSuccess(TheMessage);
  end
  else begin
    if Assigned(OnError) then
    begin
      if Assigned(AResponse) then
        OnError(TheMessage, AResponse.StatusCode, AResponse.StatusText, AResponse.ContentAsString())
      else
        OnError(TheMessage, -1, 'Response not available', '');
    end;
  end;
end;

end.
