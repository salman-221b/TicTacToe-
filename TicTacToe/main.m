clc
clear
close(allchild(0))

% figure - select player modality
ColorPSscreen = [.6 .6 .56];
Playerselected = figure('Units','normalized','Position',[.25,.25,.5,.5],'Color',ColorPSscreen,...
    'MenuBar','none','NumberTitle','off','Pointer','hand','Visible','on');
TextType = uicontrol('Style','text','Units','normalized','Position',[.125,.8,.75,.125],'String',...
    'Select Game Mode Please', 'BackgroundColor',ColorPSscreen,...
    'FontSize',22,'FontWeight','bold','ForegroundColor',[.1 0 0]);
IMAGEpvp = imread('p1vsp2.jpg');
PvP = uicontrol('Style','pushbutton','Units','normalized','Position',[.3,.25,.40625,.5],...
    'UserData','PvP','BackgroundColor',ColorPSscreen);
PvP.Units = 'pixels';

Height = PvP.Position(3);
PvP.CData = imresize(IMAGEpvp,[NaN, ceil(Height)]);
PvP.Callback = {@PlayMode,PvP};

function PlayMode(object, ~,PvP)

if strcmpi(object.UserData,'PvP')
    PvP.Enable = 'on';
    Player1text = uicontrol('Style','text','String','Player 1 name:','units','normalized',...
        'position',[.0625 .125 .2 .0625],'FontSize',14,'FontWeight','bold');
    Player1 = uicontrol('Style','edit','units','normalized','position',[.2625 .125 .2 .0625]);
    Player2text = uicontrol('Style','text','String','Player 2 name:','units','normalized',...
        'position',[.531255 .125 .2 .0625],'FontSize',14,'FontWeight','bold');
    Player2 = uicontrol('Style','edit','units','normalized','position',[.731255 .125 .2 .0625]);
    Player1.Callback = {@StartButton,'PvP',Player1,Player2};

    Player2.Callback = {@StartButton,'PvP',Player1,Player2};
    
else
    fprintf('error in play mode') 
end
end

function StartButton(~,~,Mode,Player1,Player2)

    P2 = Player2.String;
    P1 = Player1.String;

    if ~isempty(P1) && ~isempty(P2)
    StartGame = uicontrol('Style','pushbutton','Units','normalized','Position',[.35,.025,.3,.0625],...
        'String','START','FontSize',20,'FontWeight','bold','BackgroundColor',[.8 .7 .3]);
    StartGame.Callback = {@MainGame,Mode,P1,P2};
    end
end


function MainGame( ~, ~,PlayerMode,Player1name,Player2name)
close(allchild(0))
% clc, clear

PlayerMode;
Player1name
Player2name



% figure for the game
scrsz = get(groot,'ScreenSize');
Bcolor = [.6 .6 .56];
MAIN = figure('Position',scrsz,'Color',Bcolor,'MenuBar','none','NumberTitle','off',...
    'Pointer','hand','Visible','on');


% variables related to title picture figure etc stuff
TITLE = uicontrol('style','text','units','normalized','position',[.325, .91, .4, .08],'String',...
    'Tic Tac Toe!','FontWeight','bold','FontSize',50,'Backgroundcolor',Bcolor);
WHOSTURN = uicontrol('style','text','units','normalized','position',[.1, .85, .1, .05],'String',...
    'You''re Turn:','FontWeight','bold','FontSize',25,'Backgroundcolor',Bcolor);
Player1Win = uicontrol('style','text','visible','on','String',['Player 1: ',Player1name],...
    'Backgroundcolor',Bcolor,'units','normalized','position',[.05, .6, .1, .1],...
    'FontWeight','bold','FontSize',20);
Player2Win = uicontrol('style','text','visible','on','String',['Player 2: ',Player2name],...
    'Backgroundcolor',Bcolor,'units','normalized','position',[.15, .6, .1, .1],...
    'FontWeight','bold','FontSize',20);
Tie = uicontrol('style','text','visible','on','String','Ties: ',...
    'Backgroundcolor',Bcolor,'units','normalized','position',[.05, .3, .1, .1],...
    'FontWeight','bold','FontSize',20);

%decide who goes first
flip = round(rand);
if flip == 0
    StartPlayername = Player1name;
    NUM = 1;
    otherplayer = Player2name;
else
    StartPlayername = Player2name;
    NUM = -1;
    otherplayer = Player1name;
end


W = .15; % width of buttons


pic1name = 'dot.jpg';
pic1full = imread(pic1name);
pic1 = imresize(pic1full,[W*scrsz(3),NaN]);

pic2name = 'cross.jpg';
pic2full = imread(pic2name);
pic2 = imresize(pic2full,[W*scrsz(3),NaN]);


% variables related to changing data/game play
DATA.youreup = uicontrol('style','text','String',StartPlayername,'units','normalized','position',[.1, .75, .1, .1],...
    'FontWeight','bold','FontSize',25,'Backgroundcolor',Bcolor,'Value',NUM,'UserData',otherplayer);
DATA.trackplayed = uicontrol('style','text','visible','off','userdata',zeros(3,3));
DATA.player1 = uicontrol('style','text','visible','on','String','0','Value',1,'UserData',0,...
    'Backgroundcolor',Bcolor,'units','normalized','position',[.05, .47, .1, .1],...
    'FontWeight','bold','FontSize',30);
DATA.player2 = uicontrol('style','text','visible','on','String','0','Value',-1,'UserData',0,...
    'Backgroundcolor',Bcolor,'units','normalized','position',[.15, .47, .1, .1],...
    'FontWeight','bold','FontSize',30);
DATA.restart = uicontrol('style','pushbutton','units','normalized','position',[.05, .2, .2, .1],'visible','off',...
    'FontSize',35,'Backgroundcolor',[.8 .7 .3],'FontWeight','bold','String','Play Again!');
DATA.player1button = uicontrol('style','text','visible','off','String', Player1name,'UserData',pic1);
DATA.player2button = uicontrol('style','text','visible','off','String', Player2name,'UserData',pic2);
DATA.ties = uicontrol('style','text','visible','on','String','0','Value',-1,'UserData',0,...
    'Backgroundcolor',Bcolor,'units','normalized','position',[.15, .31, .1, .1],...
    'FontWeight','bold','FontSize',30);



%positions
W2Hratio = scrsz(3)/scrsz(4);
H = .15*W2Hratio;
B2T = .9 - H;
gap = .001;
for across = 1:3
    L2R = .3;
    for down = 1:3
        grid{down,across} = uicontrol('style','pushbutton','units','normalized','position',[L2R, B2T, W, H],...
            'UserData',[down,across]);
        L2R = L2R+W+gap;
    end
    B2T = B2T - (H + gap*W2Hratio);
end


for across = 1:3
    for down = 1:3
        set(grid{down,across},'Callback',{@Played,grid,DATA,PlayerMode})
    end
end


    function Played(object,~,grid,DATA,PlayerMode)
        
        Pos = object.UserData; %row,column
        %Pushed = grid{Pos(1),Pos(2)};
        
        if strcmpi(DATA.youreup.String, DATA.player1button.String)
            grid{Pos(1),Pos(2)}.CData = DATA.player1button.UserData;
        elseif strcmpi(DATA.youreup.String, DATA.player2button.String)
            grid{Pos(1),Pos(2)}.CData = DATA.player2button.UserData;
            
        else
            fprintf('Error. Player not found. Fix this...?\n')
        end
        
        %grid{Pos(1),Pos(2)}.String = DATA.youreup.String;
        %set(grid{Pos(1),Pos(2)},'enable','off')
        set(grid{Pos(1),Pos(2)},'Callback',[])
        
        Board = DATA.trackplayed.UserData; %board of plays
        
        Board(Pos(2),Pos(1)) = DATA.youreup.Value;
        DATA.trackplayed.UserData = Board;
        [IFWIN, WINNER] = CheckWin (Board);
        
        
        [DATA,grid] = PostWinCheck(IFWIN,WINNER,DATA,grid);
        
        if strcmpi(IFWIN,'yes') || strcmpi(IFWIN,'tie')
            DATA.restart.Callback = {@RestartGame,grid,DATA,PlayerMode};
        end
        
    
        
    end
    
    
    
    function RestartGame(object,~,grid,DATA,PlayerMode)
        
        object.Visible = 'off';
        for across2 = 1:3
            for down2 = 1:3
                set(grid{down2,across2},'enable','on','String','','CData',[])
                set(grid{down2,across2},'Callback',{@Played,grid,DATA,PlayerMode})
            end
        end
        
        if strcmpi(PlayerMode,'PvC') && strcmpi(DATA.youreup.String,'Computer')
            pause(1)
            firstmoverow1 = randi([1,3]);
            firstmovecol1 = randi([1,3]);
            grid{firstmovecol1,firstmoverow1}.CData = DATA.player2button.UserData;
            DATA.youreup.String = DATA.youreup.UserData;
            DATA.youreup.UserData = 'Computer';
            DATA.youreup.Value = -DATA.youreup.Value;
            StartBoard1 = zeros(3,3);
            StartBoard1(firstmoverow1,firstmovecol1) = -1;
            DATA.trackplayed.UserData = StartBoard1;
        end
        
    end

end

function [IFWIN, WINNER] = CheckWin (Board)    
    %check rows
    IFWIN = 'no'; %winner = 'yes' or no winner = 'no'
    WINNER = [];
    
    ROWcheck = sum(Board,2)';
    COLcheck = sum(Board,1);
    Diagonalcheck1 = Board(1,1)+Board(2,2)+Board(3,3);
    Diagonalcheck2 = Board(1,3)+Board(2,2)+Board(3,1);
    ALLchecks = [ROWcheck,COLcheck,Diagonalcheck1,Diagonalcheck2];
    if ~isempty(find(ALLchecks==3))
        IFWIN = 'yes';
        WINNER = 1;
    elseif ~isempty(find(ALLchecks==-3))
        IFWIN = 'yes';
        WINNER = -1;
    end
    
    if (sum(sum(Board==0)))==0 && ~strcmpi(IFWIN,'yes')
        IFWIN = 'tie';
    end
    

end

function [DATA,grid] = PostWinCheck(IFWIN,WINNER,DATA,grid)
    persistent no_tie;
    no_tie = 0;

    if strcmpi(IFWIN,'no')
        Current = DATA.youreup.String;
        Next = DATA.youreup.UserData;
        DATA.youreup.String= Next;
        DATA.youreup.UserData = Current;
        DATA.youreup.Value = -DATA.youreup.Value;
    elseif strcmpi(IFWIN,'yes')
        if WINNER == DATA.youreup.Value
            WinningPlayer = DATA.youreup.String;
        else
            WinningPlayer = DATA.youreup.UserData;
        end
        if WINNER == 1
            DATA.player1.UserData = DATA.player1.UserData + 1;
            DATA.player1.String = num2str(DATA.player1.UserData);
            uiwait(msgbox('player 1 Wins!!'))

        elseif WINNER == -1
            DATA.player2.UserData = DATA.player2.UserData + 1;
            DATA.player2.String = num2str(DATA.player2.UserData);
            uiwait(msgbox('player 2 Wins!!'))

        else
            fprintf('Error with winning count...')
        end
        DATA.trackplayed.UserData = zeros(3,3);
        DATA.restart.Visible = 'on';
        for across1 = 1:3
            for down1 = 1:3
                set(grid{down1,across1},'enable','off')
            end
        end
    elseif strcmpi(IFWIN,'tie')
        no_tie = no_tie + 1;
        DATA.trackplayed.UserData = zeros(3,3);
        DATA.ties.String = num2str(no_tie);
        uiwait(msgbox('It is a tie!!'))


        DATA.restart.Visible = 'on';
    end

end
