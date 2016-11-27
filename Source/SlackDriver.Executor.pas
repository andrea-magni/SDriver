(*
  Copyright 2016, Andrea Magni
  https://github.com/andrea-magni/SlackDriver
*)
unit SlackDriver.Executor;

interface

uses
  Classes, SysUtils
, SlackDriver.Interfaces
;

type
  TExecutor = class(TInterfacedObject, IExecutor)
  private
    FBaseURL: string;
  public
    constructor Create(ABaseURL: string = ''); virtual;
    procedure Send(AMessage: IMessage; const AOnSuccess: TProc = nil; const AOnError: TProc = nil);
    property BaseURL: string read FBaseURL write FBaseURL;
  end;

  TIncomingWebHook = class(TExecutor)
  public
  end;

implementation

uses
  System.JSON
, System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent
;

{ TExecutor }

constructor TExecutor.Create(ABaseURL: string);
begin
  inherited Create;
  FBaseURL := ABaseURL;
end;

procedure TExecutor.Send(AMessage: IMessage; const AOnSuccess: TProc; const AOnError: TProc);
var
  LClient: TNetHTTPClient;
  LRequest: TNetHTTPRequest;
  LResponse: IHTTPResponse;
  LStream: TBytesStream;
  LJSON: TJSONObject;
  LSuccess: Boolean;
begin
  LClient := TNetHTTPClient.Create(nil);
  try
    LRequest := TNetHTTPRequest.Create(nil);
    try
      LJSON := AMessage.ToJSON;
      try
        LStream := TBytesStream.Create(TEncoding.UTF8.GetBytes(LJSON.ToJSON));
        try
          LRequest.Client := LClient;
          LRequest.Accept := 'application/json';
          LResponse := LRequest.Post(FBaseURL, LStream);
          LSuccess := LResponse.StatusCode = 200;
          if LSuccess then
          begin
            if Assigned(AOnSuccess) then
              AOnSuccess();
          end
          else begin
            if Assigned(AOnError) then
              AOnError();
          end;
        finally
          LStream.Free;
        end;
      finally
        LJSON.Free;
      end;
    finally
      LRequest.Free;
    end;
  finally
    LClient.Free;
  end;
end;

end.
