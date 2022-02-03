// cTech RLV(a) quick access
//#define DEBUG 

integer gi_flag;
#define ATTACHED 0x1
#define RLV_LOGGIN 0x2
#define RLV_LOGGED 0x4
#define RLV_GET_FOLDER 0x8
#define RLV_GET_FOLDERS 0x10
#define RLV_GET_WERABLE 0x20 
#define LOCK 0x40
#define OPEN 0x80
#define ATTACH_BOTTOM 0x100
#define RLV_REPEAT 0x200
#define RLV_DELAY 0x400

#define RLV_CMD_DELAY 0.5

#define LOCK_SOUND "dec9fb53-0fef-29ae-a21d-b3047525d312"
#define UNLOCK_SOUND "82fa6d06-b494-f97c-2908-84009380c8d1"
#define CLICK_PRESS_SOUND "f231c001-cf12-340b-799a-6db2d8929f58"
#define CLICK_RELEASE_SOUND "bf55c61f-fa7e-904d-d838-cde9bf7b2264"
#define SOUND_VOLUME 0.4

#define TEXTURE_UUID "dc2bb37d-e7c6-fdb0-4d84-5b0626214352"

// Height, Width, Top, Bottom, Left, Right
// 64, 256, 5, 29, 68, 68
// PRIM_TEXTURE, 0, "dc2bb37d-e7c6-fdb0-4d84-5b0626214352", <.132813, .375, 0>, <-.43359, .23438, 0>, 0
// PRIM_TEXTURE, 0, TEXTURE_UUID, DOWN_NORMAL_SCALE, DOWN_NORMAL_OFFSET, 0
#define DOWN_NORMAL_SCALE <.132813, .375, 0>
#define DOWN_NORMAL_OFFSET <-.43359, .23438, 0>

// PRIM_TEXTURE, 0, "dc2bb37d-e7c6-fdb0-4d84-5b0626214352", <.132813, .375, 0>, <-.30078, .23438, 0>, 0
// PRIM_TEXTURE, 0, TEXTURE_UUID, DOWN_PRESS_SCALE, DOWN_PRESS_OFFSET, 0
#define DOWN_PRESS_SCALE <.132813, .375, 0>
#define DOWN_PRESS_OFFSET <-.30078, .23438, 0>

// PRIM_TEXTURE, 0, "dc2bb37d-e7c6-fdb0-4d84-5b0626214352", <.132813, .375, 0>, <-.43359, -.14063, 0>, 0
// PRIM_TEXTURE, 0, TEXTURE_UUID, UP_NORMAL_SCALE, UP_NORMAL_OFFSET, 0
#define UP_NORMAL_SCALE <.132813, .375, 0>
#define UP_NORMAL_OFFSET <-.43359, -.14063, 0>

// PRIM_TEXTURE, 0, "dc2bb37d-e7c6-fdb0-4d84-5b0626214352", <.132813, .375, 0>, <-.30078, -.14063, 0>, 0
// PRIM_TEXTURE, 0, TEXTURE_UUID, UP_PRESS_SCALE, UP_PRESS_OFFSET, 0
#define UP_PRESS_SCALE <.132813, .375, 0>
#define UP_PRESS_OFFSET <-.30078, -.14063, 0>

// 64, 256, 5, 29, 68, 250
// PRIM_TEXTURE, 0, "dc2bb37d-e7c6-fdb0-4d84-5b0626214352", <.710938, .375, 0>, <.12109, .23438, 0>, 0
// PRIM_TEXTURE, 0, TEXTURE_UUID, SELECT_NORMAL_SCALE, SELECT_NORMAL_OFFSET, 0
#define SELECT_NORMAL_SCALE <.710938, .375, 0>
#define SELECT_NORMAL_OFFSET <.12109, .23438, 0>

// 64, 256, 29, 53, 68, 250
// PRIM_TEXTURE, 0, "dc2bb37d-e7c6-fdb0-4d84-5b0626214352", <.710938, .375, 0>, <.12109, -.14063, 0>, 0
// PRIM_TEXTURE, 0, TEXTURE_UUID, SELECT_PRESS_SCALE, SELECT_PRESS_OFFSET, 0
#define SELECT_PRESS_SCALE <.710938, .375, 0>
#define SELECT_PRESS_OFFSET <.12109, -.14063, 0>

#define COLOR_WORN <0.224, 0.800, 0.800>
#define COLOR_NORMAL <0.067, 0.067, 0.067>

#define PARAMS_SLIDE 14

#define TIMER_MIN_TIME 0.022444
#define INT_MAX 0x7FFFFFFF

#define bool(x) !!(x)

#define DEEP_OFFSET 1
#define BUTTON_SPACING 0.002
#define TEXT_ADJUST 0.011

#define JSON_KEY "fold"
#define JSON_NAME "name"
#define JSON_WORN "worn"
#define JSON_BUTTON "button"
#define JSON_TEXT "text"

string gs_wearer;
integer gi_att_point;

// UI
integer gi_touch_time;
vector gv_root_size = <0.025, 0.02, 0.02>;
vector gv_button_size = <.035, .175, .025>;
float gf_h_offset;
list gl_open_params;

// RLV
integer gi_login_try;
string gs_root_path;
integer gi_fold_numb;
string gj_worn_info;
list gl_worn_info;
string gs_reapeat;

// CHAT
integer gi_listen_handle;
string gs_channel;

#ifdef DEBUG
print_flag()
{
    string msg;
    if (gi_flag & ATTACHED) msg += "ATTACHED ";
    if (gi_flag & RLV_LOGGIN) msg += "RLV_LOGGIN ";
    if (gi_flag & RLV_LOGGED) msg += "RLV_LOGGED ";
    if (gi_flag & RLV_GET_FOLDER) msg += "RLV_GET_FOLDER ";
    if (gi_flag & RLV_GET_FOLDERS) msg += "RLV_GET_FOLDERS ";
    if (gi_flag & RLV_GET_WERABLE) msg += "RLV_GET_WERABLE ";
    if (gi_flag & LOCK) msg += "LOCK ";
    if (gi_flag & OPEN) msg += "OPEN ";
    if (gi_flag & ATTACH_BOTTOM) msg += "ATTACH_BOTTOM ";
    if (gi_flag & RLV_REPEAT) msg += "RLV_REPEAT ";
    if (gi_flag & RLV_DELAY) msg += "RLV_DELAY ";
    llOwnerSay(msg);
}
#endif

string json_escape(string str) 
{
	list esc_char = ["%5b", "%5d", "%7b", "%7d", "%27", "%22", "%3A"];
	integer len = 7;
	while(len) 
    {
		string char = llEscapeURL(llList2String(esc_char, --len));
		str = llDumpList2String(llParseStringKeepNulls(str, (list)char, []), llList2String(esc_char, len));
	}
	return llEscapeURL(str);
}

set_text(string skey)
{
    vector color = COLOR_NORMAL;
    if (llJsonGetValue(gj_worn_info, [skey, JSON_WORN]) == "1")
        color = COLOR_WORN;

    string name = llUnescapeURL(llJsonGetValue(gj_worn_info, [skey, JSON_NAME]));
    llSetLinkPrimitiveParamsFast(
        (integer)llJsonGetValue(gj_worn_info, [skey, JSON_TEXT]), 
        [ PRIM_TEXT, llGetSubString(name, 0, 15), color, 1 ]
    );
}

open(integer open)
{
    list ldata;
    gi_flag = (gi_flag & ~OPEN) | (-bool(open) & OPEN);
    if (open)
    {
        llSetLinkPrimitiveParamsFast(LINK_ROOT, llList2List(gl_open_params, 0, ~-PARAMS_SLIDE * gi_fold_numb));
        integer it;
        for (;it < gi_fold_numb; ++it)
            set_text(JSON_KEY + (string)it);

        gi_flag = gi_flag | RLV_DELAY;
        llSetTimerEvent(RLV_CMD_DELAY);
    }
    else 
    {
        llSetPrimitiveParams([
            PRIM_LINK_TARGET, LINK_ALL_CHILDREN, 
            PRIM_POS_LOCAL, <DEEP_OFFSET, 0, 0>,
            PRIM_COLOR, ALL_SIDES, <1,1,1>, 0,
            PRIM_SIZE, ZERO_VECTOR,
            PRIM_TEXT, "", ZERO_VECTOR, 0
        ]);
    }
}

lock (integer lock) 
{
    string text = "y";
    vector color = <1,0,0>;
    string sound = UNLOCK_SOUND;

    gi_flag = (gi_flag & ~LOCK) | (-bool(lock) & LOCK);

    if (lock) 
    {
        text = "n";
        color = <0,1,0>;
        sound = LOCK_SOUND;
    }

    llOwnerSay( "@detach=" + text );
    llSetColor( color, ALL_SIDES );
    llPlaySound( sound, SOUND_VOLUME);
}

string data_by_folder(string folder) 
{
    folder = json_escape(folder);

    integer it;
    for (;it < gi_fold_numb; ++it)
    {
        string skey = JSON_KEY + (string)it;
        if (llJsonGetValue(gj_worn_info, [skey, JSON_NAME]) == folder)
            return skey;
    }

    return "";
}

stat_up()
{
    gi_flag = (gi_flag & ~(ATTACHED | ATTACH_BOTTOM | RLV_LOGGED | LOCK | OPEN)) | (-bool(gi_att_point) & ATTACHED);
    
    vector pos = llGetLocalPos();
    float root_half = (gv_root_size.y * 0.5);
    gf_h_offset = 0;
    list texture = [ PRIM_TEXTURE, ALL_SIDES, TEXTURE_UUID, DOWN_NORMAL_SCALE, DOWN_NORMAL_OFFSET, 0 ];
    
    if (gi_att_point == ATTACH_HUD_TOP_RIGHT || gi_att_point == ATTACH_HUD_BOTTOM_RIGHT) 
    {
        gf_h_offset = (gv_button_size.y * 0.5) - root_half;
        if (pos.y < root_half) pos.y = root_half;
    }
    else if (gi_att_point == ATTACH_HUD_TOP_LEFT || gi_att_point == ATTACH_HUD_BOTTOM_LEFT)
    {
        gf_h_offset = -((gv_button_size.y * 0.5) - (gv_root_size.y * 0.5));
        if (pos.y > -root_half) pos.y = -root_half;
    }

    if (gi_att_point == ATTACH_HUD_TOP_RIGHT || gi_att_point == ATTACH_HUD_TOP_CENTER || gi_att_point == ATTACH_HUD_TOP_LEFT)
    {
        if (pos.z > -0.1) pos.z = -0.1;
    }
    else if (gi_att_point == ATTACH_HUD_BOTTOM_LEFT || gi_att_point == ATTACH_HUD_BOTTOM || gi_att_point == ATTACH_HUD_BOTTOM_RIGHT)
    {
        if (pos.z < 0.05) pos.z = 0.05;
        texture = [ PRIM_TEXTURE, ALL_SIDES, TEXTURE_UUID, UP_NORMAL_SCALE, UP_NORMAL_OFFSET, 0 ];
        gi_flag = gi_flag | ATTACH_BOTTOM;
    }

    llSetLinkPrimitiveParamsFast(LINK_ROOT, (list)PRIM_POS_LOCAL + pos + texture);
    llSetPrimitiveParams([
        PRIM_LINK_TARGET, LINK_ROOT,
        PRIM_ROT_LOCAL, ZERO_ROTATION,
        PRIM_SIZE, gv_root_size,

        PRIM_LINK_TARGET, LINK_ALL_CHILDREN,
        PRIM_POS_LOCAL, <DEEP_OFFSET, 0, 0>, 
        PRIM_ROT_LOCAL, ZERO_ROTATION,
        PRIM_SIZE, ZERO_VECTOR,
        PRIM_TEXTURE, ALL_SIDES, TEXTURE_UUID, SELECT_NORMAL_SCALE, SELECT_NORMAL_OFFSET, 0,

        PRIM_LINK_TARGET, LINK_SET,
        PRIM_TEXT, "", ZERO_VECTOR, 0
    ]);

    
    gl_open_params = [];
    integer it;
    for(;it < 20; ++it)
    {
        float offset;
        if (gi_flag & ATTACH_BOTTOM)
            offset = ((gv_button_size.z * -~it) + (BUTTON_SPACING * -~it));
        else
            offset = ((-gv_button_size.z * -~it) - (BUTTON_SPACING * -~it));

        gl_open_params = gl_open_params + 
        [
            PRIM_LINK_TARGET, (it << 1) + 2,
            PRIM_POS_LOCAL, <0, gf_h_offset, offset>,
            PRIM_COLOR, ALL_SIDES, <1,1,1>, 1,
            PRIM_SIZE, gv_button_size,

            PRIM_LINK_TARGET, (it << 1) + 3,
            PRIM_POS_LOCAL, <0, gf_h_offset, offset - ((gv_button_size.z * 0.5) + TEXT_ADJUST)>
        ];
    }
    
    gs_wearer = llGetOwner();
    integer channel = 1000000 + (integer)llFrand(200000000);
    gs_channel = (string)channel;
    gi_listen_handle = llListen(channel, llKey2Name(gs_wearer), gs_wearer, "");

    gi_login_try = 0;
    gi_flag = gi_flag | RLV_LOGGIN;
    llOwnerSay("@versionnew=" + gs_channel);
    llSetTimerEvent(5);
}

default
{

    state_entry()
    {
        llSetTimerEvent(0);
        gj_worn_info = "";
        integer it;
        for (; it < 20; ++it)
        {
            string skey = JSON_KEY + (string)it;
            gj_worn_info = llJsonSetValue(gj_worn_info, [skey, JSON_NAME], "");
            gj_worn_info = llJsonSetValue(gj_worn_info, [skey, JSON_WORN], "0");
            gj_worn_info = llJsonSetValue(gj_worn_info, [skey, JSON_BUTTON], (string)((it << 1) + 2));
            gj_worn_info = llJsonSetValue(gj_worn_info, [skey, JSON_TEXT], (string)((it << 1) + 3));
        }

        gi_att_point = llGetAttached();
        if (!gi_att_point) state off;

        stat_up();
    }

    on_rez( integer start_param)
    {
        llSetTimerEvent(0);
        gi_att_point = llGetAttached();
        if (!gi_att_point) state off;
    }

    attach( key id )
    {
        llListenRemove(gi_listen_handle);
        if (id) 
        {
            if (gs_wearer == id) 
                llSleep(15);
            stat_up();
        }
        else 
            llOwnerSay("@clear");
        gs_wearer = id;
    }

    listen( integer channel, string name, key id, string message )
    {

        if (~gi_flag & ATTACHED) return;
#ifdef DEBUG
        llOwnerSay(message);
        print_flag();
#endif
        
        float time;
        string msg;
        if (gi_flag & RLV_LOGGIN) 
        {
            if(!llSubStringIndex(message, "RestrainedLove viewer ")) 
            {
                msg = "@getpath:" + (string)llGetKey() + "=" + gs_channel;
                lock(TRUE);
                gi_flag = (gi_flag & ~RLV_LOGGIN) | (RLV_LOGGED | RLV_GET_FOLDER);
                time = 60.0;
            }
        } 
        else if ((gi_flag & (RLV_LOGGED | RLV_GET_FOLDER)) == (RLV_LOGGED | RLV_GET_FOLDER))
        {
            gs_root_path = message;
            gi_flag = (gi_flag & ~RLV_GET_FOLDER) | RLV_GET_FOLDERS;
            msg = "@getinv:" + gs_root_path + "=" + gs_channel;
            time = 60.0;
        }
        else if ((gi_flag & (RLV_LOGGED | RLV_GET_FOLDERS)) == (RLV_LOGGED | RLV_GET_FOLDERS))
        {
            gi_flag = gi_flag & ~RLV_GET_FOLDERS | RLV_GET_WERABLE;
            list folds = llListSort(llList2List(llParseString2List(message, (list)",", []), 0, 20), 1, TRUE);

            integer len = llGetListLength(folds);
            gi_fold_numb = len;
            while(~--len)
            {
                string name = json_escape(llList2String(folds, len));
                gj_worn_info = llJsonSetValue(gj_worn_info, [JSON_KEY + (string)len, JSON_NAME], name);
            }

            msg = "@getinvworn:" + gs_root_path + "=" + gs_channel;
            time = 60.0;
        }
        else if ((gi_flag & (RLV_LOGGED | RLV_GET_WERABLE)) == (RLV_LOGGED | RLV_GET_WERABLE))
        {
            gl_worn_info = llList2List(llParseString2List(message, (list)"," + "|", []), 1, -1);
            gi_flag = gi_flag & ~RLV_GET_WERABLE;
            llMessageLinked(LINK_THIS, 0, "folder", "");
            time = 1;
        }

        if (msg) llOwnerSay(msg);
        if (time) llSetTimerEvent(time);
        else llListenControl(gi_listen_handle, FALSE);
    }

    link_message( integer sender_num, integer num, string str, key id )
    {
        if (~gi_flag & RLV_LOGGED) return;

        if (str == "open")
            open(!(gi_flag & OPEN));
        else if (str == "folder")
        {
            if (!llGetListLength(gl_worn_info)) return;

            string sdata = llList2String(gl_worn_info, 1);
            string worn = (string)(bool(~llSubStringIndex(sdata, "2") || ~llSubStringIndex(sdata, "3")));
            string skey = data_by_folder(llList2String(gl_worn_info, 0));

            if (skey == "")
            {
                llShout(DEBUG_CHANNEL, "ERROR: unknow folder: " + llList2String(gl_worn_info, 0));
                return;
            }

            if (llJsonGetValue(gj_worn_info, [skey, JSON_WORN]) != worn) 
            {
                gj_worn_info = llJsonSetValue(gj_worn_info, [skey, JSON_WORN], worn);
                if (gi_flag & OPEN) 
                    set_text(skey);
            }

            gl_worn_info = llDeleteSubList(gl_worn_info, 0, 1);
            if(gl_worn_info) 
                llMessageLinked(LINK_THIS, 0, "folder", "");
        }
    }

    timer()
    {
        string msg;
        if (gi_flag & RLV_LOGGIN) 
        {
            if (++gi_login_try < 5) 
                msg = "@versionnew=" + gs_channel;
            else 
                gi_flag = gi_flag & ~RLV_LOGGIN;
        }
        else if (gi_flag & RLV_REPEAT) 
        {
            msg = (gs_reapeat = "") + gs_reapeat;
            gi_flag = gi_flag & ~RLV_REPEAT | RLV_DELAY;
        }
        else if (gi_flag & RLV_DELAY) 
        {
             gi_flag = gi_flag & ~RLV_DELAY | RLV_GET_WERABLE;
             msg = "@getinvworn:" + gs_root_path + "=" + gs_channel;
             llSetTimerEvent(60);
        }
        else
        {
            llSetTimerEvent(0);
            llListenControl(gi_listen_handle, FALSE);
        }

        if (msg)
            llOwnerSay(msg);
    }

    touch_start( integer num_detected )
    {
        if (~gi_flag & RLV_LOGGED) return;

        integer link = llDetectedLinkNumber(0);
        integer side = llDetectedTouchFace(0);
        list params;

        if (link == LINK_ROOT) 
        {
            if (gi_flag & OPEN) 
            {
                if (gi_flag & ATTACH_BOTTOM)
                    params = [ PRIM_TEXTURE, side, TEXTURE_UUID, DOWN_PRESS_SCALE, DOWN_PRESS_OFFSET, 0 ];
                else
                    params = [ PRIM_TEXTURE, side, TEXTURE_UUID, UP_PRESS_SCALE, UP_PRESS_OFFSET, 0 ];
            }
            else 
            {
                if (gi_flag & ATTACH_BOTTOM)
                    params = [ PRIM_TEXTURE, side, TEXTURE_UUID, UP_PRESS_SCALE, UP_PRESS_OFFSET, 0 ];
                else
                    params = [ PRIM_TEXTURE, side, TEXTURE_UUID, DOWN_PRESS_SCALE, DOWN_PRESS_OFFSET, 0 ];
            }
            gi_touch_time = llGetUnixTime();
        }
        else if (gi_flag & OPEN)
            params = [ PRIM_TEXTURE, side, TEXTURE_UUID, SELECT_PRESS_SCALE, SELECT_PRESS_OFFSET, 0 ];

        llPlaySound(CLICK_PRESS_SOUND, SOUND_VOLUME);
        if (params)
            llSetLinkPrimitiveParamsFast(link, params);
    }

    touch( integer num_detected )
    {
        if (~gi_flag & RLV_LOGGED) return;
        if (llDetectedLinkNumber(0) != LINK_ROOT) return;

        if ((llGetUnixTime() - gi_touch_time) > 2) 
        {
            lock(!(gi_flag & LOCK));
            gi_touch_time = INT_MAX;
        }
    }

    touch_end( integer num_detected )
    {
        if (~gi_flag & RLV_LOGGED) return;
        integer link = llDetectedLinkNumber(0);
        integer side = llDetectedTouchFace(0);

        string msg;
        list params;

        if (link == LINK_ROOT)  
        {

            if (gi_flag & OPEN) 
            {
                if (gi_touch_time == INT_MAX) 
                {
                    if (gi_flag & ATTACH_BOTTOM)
                        params = [ PRIM_TEXTURE, side, TEXTURE_UUID, DOWN_NORMAL_SCALE, DOWN_NORMAL_OFFSET, 0 ];
                    else
                        params = [ PRIM_TEXTURE, side, TEXTURE_UUID, UP_NORMAL_SCALE, UP_NORMAL_OFFSET, 0 ];
                }
                else
                {
                    if (gi_flag & ATTACH_BOTTOM)
                        params = [ PRIM_TEXTURE, side, TEXTURE_UUID, UP_NORMAL_SCALE, UP_NORMAL_OFFSET, 0 ];
                    else
                        params = [ PRIM_TEXTURE, side, TEXTURE_UUID, DOWN_NORMAL_SCALE, DOWN_NORMAL_OFFSET, 0 ];
                }
                
            }
            else 
            {
                if (gi_touch_time == INT_MAX) 
                {
                    if (gi_flag & ATTACH_BOTTOM)
                        params = [ PRIM_TEXTURE, side, TEXTURE_UUID, UP_NORMAL_SCALE, UP_NORMAL_OFFSET, 0 ];
                    else
                        params = [ PRIM_TEXTURE, side, TEXTURE_UUID, DOWN_NORMAL_SCALE, DOWN_NORMAL_OFFSET, 0 ];
                }
                else
                {
                    if (gi_flag & ATTACH_BOTTOM)
                        params = [ PRIM_TEXTURE, side, TEXTURE_UUID, DOWN_NORMAL_SCALE, DOWN_NORMAL_OFFSET, 0 ];
                    else
                        params = [ PRIM_TEXTURE, side, TEXTURE_UUID, UP_NORMAL_SCALE, UP_NORMAL_OFFSET, 0 ];
                }
            }
        }
        else
        {
            params = [ PRIM_TEXTURE, side, TEXTURE_UUID, SELECT_NORMAL_SCALE, SELECT_NORMAL_OFFSET, 0, PRIM_LINK_TARGET, LINK_ROOT ];
            if (gi_flag & ATTACH_BOTTOM)
                params += [ PRIM_TEXTURE, side, TEXTURE_UUID, UP_NORMAL_SCALE, UP_NORMAL_OFFSET, 0 ];
            else
                params += [ PRIM_TEXTURE, side, TEXTURE_UUID, DOWN_NORMAL_SCALE, DOWN_NORMAL_OFFSET, 0 ];

            string skey = llList2String(llGetLinkPrimitiveParams(link, (list)PRIM_DESC), 0);
            if (llJsonGetValue(gj_worn_info, [skey, JSON_WORN]) == "0")
                msg = "@attachallover:";
            else
                msg = "@detachall:";
            
            msg += gs_root_path + "/" + llUnescapeURL(llJsonGetValue(gj_worn_info, [skey, JSON_NAME])) + "=force";
            gs_reapeat = msg;
            gi_flag = gi_flag | RLV_REPEAT;
            llSetTimerEvent(RLV_CMD_DELAY);
            
        }

        if (gi_touch_time != INT_MAX)
            llMessageLinked(LINK_THIS, 0, "open", "");

        llPlaySound(CLICK_RELEASE_SOUND, SOUND_VOLUME);
        if (params) 
            llSetLinkPrimitiveParamsFast(link, params);

        if (msg) 
        {
            llListenControl(gi_listen_handle, TRUE);
            llSleep(TIMER_MIN_TIME);
            llOwnerSay(msg);
        }

        
    }

}

state off 
{
    attach( key id )
    {
        if (id) state default;
    }
}
