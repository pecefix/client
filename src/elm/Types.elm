module Types exposing (..)

import Html5.DragDrop as DragDrop
import Json.Decode as Json


type Msg
    = NoOp
      -- === Card Activation ===
    | Activate String
      -- === Card Editing  ===
    | OpenCard String String
    | DeleteCard String
      -- === Card Insertion  ===
    | InsertAbove String
    | InsertBelow String
    | InsertChild String
      -- === Card Moving  ===
    | DragDropMsg (DragDrop.Msg String DropId)
      -- === History ===
    | CheckoutCommit String
    | Undo
    | Redo
    | Sync
    | SetSelection String Selection String
    | Resolve String
      -- === Help ===
    | VideoModal Bool
    | ShortcutTrayToggle
      -- === Ports ===
    | Port IncomingMsg
    | LogErr String


type
    OutgoingMsg
    -- === Dialogs, Menus, Window State ===
    = Alert String
    | SaveAndClose (Maybe ( Json.Value, Json.Value ))
    | ConfirmCancelCard String String
    | ColumnNumberChange Int
      -- === Database ===
    | SaveToDB ( Json.Value, Json.Value )
    | SaveLocal Tree
    | Push
    | Pull
      -- === File System ===
    | ExportDOCX String (Maybe String)
    | ExportJSON Tree (Maybe String)
    | ExportTXT Bool Tree (Maybe String)
    | ExportTXTColumn Int Tree (Maybe String)
      -- === DOM ===
    | ActivateCards ( String, Int, List (List String) )
    | FlashCurrentSubtree
    | TextSurround String String
      -- === UI ===
    | UpdateCommits ( Json.Value, Maybe String )
    | SetVideoModal Bool
    | SetShortcutTray Bool
      -- === Misc ===
    | SocketSend CollabState
    | ConsoleLogRequested String


type
    IncomingMsg
    -- === Dialogs, Menus, Window State ===
    = IntentExit
    | IntentExport ExportSettings
    | CancelCardConfirmed
      -- === Database ===
    | SetHeadRev String
    | Merge Json.Value
      -- === DOM ===
    | FieldChanged String
    | TextSelected Bool
      -- === UI ===
    | ViewVideos
    | Keyboard String Int
      -- === Misc ===
    | RecvCollabState CollabState
    | CollaboratorDisconnected String


type alias OutsideData =
    { tag : String, data : Json.Value }


type alias ExportSettings =
    { format : ExportFormat
    , selection : ExportSelection
    , filepath : Maybe String
    }


type ExportFormat
    = DOCX
    | JSON
    | TXT


type ExportSelection
    = All
    | CurrentSubtree
    | ColumnNumber Int


type alias Tree =
    { id : String
    , content : String
    , children : Children
    }


type Children
    = Children (List Tree)


type alias Group =
    List Tree


type alias Column =
    List (List Tree)


type Op
    = Ins String String (List String) Int
    | Mod String (List String) String String
    | Del String (List String)
    | Mov String (List String) Int (List String) Int


type Selection
    = Original
    | Ours
    | Theirs
    | Manual


type alias Conflict =
    { id : String
    , opA : Op
    , opB : Op
    , selection : Selection
    , resolved : Bool
    }


type Status
    = Bare
    | Clean String
    | MergeConflict Tree String String (List Conflict)


type Mode
    = Active String
    | Editing String


type DropId
    = Above String
    | Below String
    | Into String


type alias CollabState =
    { uid : String
    , mode : Mode
    , field : String
    }


type alias ViewState =
    { active : String
    , activePast : List String
    , activeFuture : List String
    , descendants : List String
    , ancestors : List String
    , editing : Maybe String
    , dragModel : DragDrop.Model String DropId
    , draggedTree : Maybe ( Tree, String, Int )
    , copiedTree : Maybe Tree
    , collaborators : List CollabState
    }


type alias VisibleViewState =
    { active : String
    , editing : Maybe String
    , descendants : List String
    , ancestors : List String
    , dragModel : DragDrop.Model String DropId
    , collaborators : List CollabState
    }


type alias WordCount =
    { card : Int
    , subtree : Int
    , group : Int
    , column : Int
    , document : Int
    }
