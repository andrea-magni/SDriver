(*
  Copyright 2016, Andrea Magni
  https://github.com/andrea-magni/SlackDriver
*)
unit Forms.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Actions,
  Vcl.ActnList;

type
  TForm1 = class(TForm)
    EditMessage: TEdit;
    ButtonSend: TButton;
    Label1: TLabel;
    EditUserName: TEdit;
    Label2: TLabel;
    EditIcon_URL: TEdit;
    Label3: TLabel;
    EditIcon_Emoji: TEdit;
    Label4: TLabel;
    EditChannel: TEdit;
    Label5: TLabel;
    EditWebHookURL: TEdit;
    Label6: TLabel;
    ActionList1: TActionList;
    SendAction: TAction;
    procedure SendActionExecute(Sender: TObject);
    procedure SendActionUpdate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  System.Diagnostics
, SlackDriver.Message, SlackDriver.Interfaces, SlackDriver.IncomingWebHook
;

procedure TForm1.SendActionExecute(Sender: TObject);
var
  LWebHook: IMessageBuffer;
  LMessage: IMessage;

  LStopWatch: TStopWatch;
begin
  LStopWatch := TStopWatch.StartNew;

  LMessage := TMessage.Create(EditMessage.Text + ' [' + TimeToStr(Now) + ']');
  LMessage.UserName := EditUserName.Text;
  LMessage.Icon_URL := EditIcon_URL.Text;
  LMessage.Icon_Emoji := EditIcon_Emoji.Text;
  LMessage.Channel := EditChannel.Text;

  LWebHook := TIncomingWebHook.Create(EditWebHookURL.Text, False);
  LWebHook.Push(LMessage);
  LWebHook.Flush;
end;

procedure TForm1.SendActionUpdate(Sender: TObject);
begin
  SendAction.Enabled := (EditWebHookURL.Text <> '') and (EditMessage.Text <> '');
end;

end.
