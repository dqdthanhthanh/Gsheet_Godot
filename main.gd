extends Node2D

# I HAVE ADDED KEY ALSO BUT DON'T WORRY I AM GOING TO CHANGE KEY
onready var http = $HTTPRequest
var date = ""
var time = ""
var cate = ""
var amount = ""
var desc = ""
var respheader = ""
var SEND = false

var excel_file = "https://docs.google.com/spreadsheets/d/1BxOynf2MqJURThmiUzzOts4i360y1pUliJSAkjYljAE/edit?gid=0#gid=0"
var sheet_id = "1BxOynf2MqJURThmiUzzOts4i360y1pUliJSAkjYljAE"
var app_script_id = "AKfycbyAZP-lPX5xgmj_BrxQ96GmPXB_1dKylRE9PhH1UcdYpBO68F01IFI-7VzbLvPHW205lg"
var app_script_url = "https://script.google.com/macros/s/" + app_script_id+ "/exec"

func _ready():
	getdata()
	
func getdata():
	$Label.text = "Fetching: "+"RESULTS"
	$HTTPRequest.request(app_script_url+"?sheetname="+"RESULTS")
	SEND = false

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if SEND:
		pass
	else:
		respheader = headers
		if response_code == 200:
			$Label.text = "Fetched: "+"RESULTS"
			var json = JSON.parse(body.get_string_from_utf8())
			print(json.result)
			var data = body.get_string_from_utf8()
			data = parse_json(data)[0]
			$CASH_IN_HAND.text = "CASH IN HAND:  "+str(data["TOTAL_CASH_IN_HAND"])
			$TOTAL_INCOME.text = "TOTAL INCOME:  "+str(data["TOTAL_INCOME"])
			$TOTAL_EXPENSE.text = "TOTAL EXPENSE: "+str(data["TOTAL_EXPENSE"])
		else:
			prints('response_code',response_code)
			$Label.text = "Trying again response code: "+str(response_code)
			getdata()

func _on_SEND_pressed():
	SEND = true
	$Label.text = "SENDING DATA"
	date = str($DATE.text)
	time = str($TIME.text)
	cate = $I_E.get_item_text($I_E.selected)
	amount = str($AMOUNT.text)
	desc = str($DESC.text)
	
	var datasend = "?date="+date+"&time="+time+"&cate="+cate+"&amount="+amount+"&desc="+desc+"&sheetname="+"DATA"
	prints(datasend)
	var headers = ["Content-Length: 0"]
	var posturl = app_script_url+datasend
	$HTTPRequest.request(posturl,headers,true, HTTPClient.METHOD_POST)
	SEND = true
	$Label.text = "SEND COMPLETED"


func _on_ref_pressed():
	getdata()


