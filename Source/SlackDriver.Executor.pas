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
  TNetHTTPRequestAndClient = class(TNetHTTPRequest)
  public
    TheClient: TNetHTTPClient;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TExecutor = class(TInterfacedObject, IExecutor)
  private
    FBaseURL: string;
    FAsynchronous: Boolean;
  protected
    procedure InternalSend(const AURL: string; const AMessage: IMessage;
      const AOnSuccess: TOnSuccessProc; const AOnError: TOnErrorProc); virtual;
  public
    constructor Create(const ABaseURL: string = ''; const AAsync: Boolean = True); virtual;
    destructor Destroy; override;

    // IExecutor
    procedure Send(AMessage: IMessage; const AOnSuccess: TProc<IMessage> = nil;
      const AOnError: TProc<IMessage, Integer, string, string> = nil); virtual;

    property BaseURL: string read FBaseURL write FBaseURL;
    property Asynchronous: Boolean read FAsynchronous write FAsynchronous;
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

procedure TExecutor.InternalSend(
  const AURL: string; const AMessage: IMessage;
  const AOnSuccess: TOnSuccessProc; const AOnError: TOnErrorProc);
var
  FRequest: TNetHTTPRequestAndClient;
  LStream: TBytesStream;
  LJSON: TJSONObject;
  LResponse: IHTTPResponse;
  LSuccess: Boolean;
begin
  FRequest := TNetHTTPRequestAndClient.Create(nil);
  try
    LJSON := AMessage.ToJSON;
    try
      LStream := TBytesStream.Create(TEncoding.UTF8.GetBytes(LJSON.ToJSON));
      try
        FRequest.Asynchronous := False;
        LResponse := FRequest.Post(AURL, LStream);

        LSuccess := Assigned(LResponse) and (LResponse.StatusCode = 200);
        if LSuccess then
        begin
          if Assigned(AOnSuccess) then
            AOnSuccess(AMessage);
        end
        else begin
          if Assigned(AOnError) then
          begin
            if Assigned(LResponse) then
              AOnError(AMessage, LResponse.StatusCode, LResponse.StatusText, LResponse.ContentAsString())
            else
              AOnError(AMessage, -1, 'Response not available', '');
          end;
        end;

      finally
        LStream.Free;
      end;
    finally
      LJSON.Free;
    end;
  finally
    FRequest.Free;
  end;
end;

procedure TExecutor.Send(AMessage: IMessage; const AOnSuccess: TOnSuccessProc;
  const AOnError: TOnErrorProc);

  procedure SendAsync(const AURL: string; const AMessage: IMessage;
    const AOnSuccess: TOnSuccessProc; const AOnError: TOnErrorProc);
  begin
    TTask.Run(
      procedure
      begin
        InternalSend(AURL, AMessage, AOnSuccess, AOnError);
      end
    );
  end;

begin
  if Asynchronous then
    SendAsync(BaseURL, AMessage, AOnSuccess, AOnError)
  else
    InternalSend(BaseURL, AMessage, AOnSuccess, AOnError);
end;

{ TNetHTTPRequestAndClient }

constructor TNetHTTPRequestAndClient.Create(AOwner: TComponent);
begin
  inherited;
  TheClient := TNetHTTPClient.Create(nil);
  try
    Self.Client := TheClient;
  except
    TheClient.Free;
  raise;
  end;
end;

destructor TNetHTTPRequestAndClient.Destroy;
begin
  FreeAndNil(TheClient);
  inherited;
end;

end.
