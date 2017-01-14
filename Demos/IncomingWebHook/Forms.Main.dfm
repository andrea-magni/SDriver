object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'SDriver Incoming WebHook Demo'
  ClientHeight = 220
  ClientWidth = 734
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    734
    220)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 5
    Top = 37
    Width = 150
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Message'
  end
  object Label2: TLabel
    Left = 5
    Top = 64
    Width = 150
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Username'
  end
  object Label3: TLabel
    Left = 5
    Top = 91
    Width = 150
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Icon URL'
  end
  object Label4: TLabel
    Left = 5
    Top = 118
    Width = 150
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Icon Emoji'
  end
  object Label5: TLabel
    Left = 5
    Top = 145
    Width = 150
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Channel'
  end
  object Label6: TLabel
    Left = 5
    Top = 10
    Width = 150
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Incoming WebHook URL'
  end
  object EditMessage: TEdit
    Left = 160
    Top = 34
    Width = 565
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'Hello, world!'
  end
  object ButtonSend: TButton
    Left = 650
    Top = 177
    Width = 75
    Height = 25
    Action = SendAction
    Anchors = [akTop, akRight]
    TabOrder = 6
  end
  object EditUserName: TEdit
    Left = 160
    Top = 61
    Width = 565
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    TextHint = '(default)'
  end
  object EditIcon_URL: TEdit
    Left = 160
    Top = 88
    Width = 565
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
  end
  object EditIcon_Emoji: TEdit
    Left = 160
    Top = 115
    Width = 565
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
  end
  object EditChannel: TEdit
    Left = 160
    Top = 142
    Width = 565
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 5
    TextHint = '(default)'
  end
  object EditWebHookURL: TEdit
    Left = 160
    Top = 7
    Width = 565
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    TextHint = '(https://hooks.slack.com/services/...)'
  end
  object ActionList1: TActionList
    Left = 512
    Top = 168
    object SendAction: TAction
      Caption = 'Send'
      OnExecute = SendActionExecute
      OnUpdate = SendActionUpdate
    end
  end
end
