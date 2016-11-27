(*
  Copyright 2016, Andrea Magni
  https://github.com/andrea-magni/SlackDriver
*)
unit Forms.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    EditMessage: TEdit;
    SendButton: TButton;
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
    procedure SendButtonClick(Sender: TObject);
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
  SlackDriver.Message
, SlackDriver.Interfaces
, SlackDriver.Executor
;

procedure TForm1.SendButtonClick(Sender: TObject);
var
  LExecutor: IExecutor;
  LMessage: IMessage;
begin
  LMessage := TMessage.Create(EditMessage.Text);
  LMessage.UserName := EditUserName.Text;
  LMessage.Icon_URL := EditIcon_URL.Text;
  LMessage.Icon_Emoji := EditIcon_Emoji.Text;
  LMessage.Channel := EditChannel.Text;

  LExecutor := TIncomingWebHook.Create(EditWebHookURL.Text);

  LExecutor.Send(
       LMessage
     , procedure
       begin
         ShowMessage('OK, sent!');
       end
     , procedure
       begin
         ShowMessage('Failed!');
       end
    );
end;

end.
