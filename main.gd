extends Node2D

# I HAVE ADDED KEY ALSO BUT DON'T WORRY I AM GOING TO CHANGE KEY
onready var http = $HTTPRequest
var sheetname = "RESULTS"
var date = ""
var time = ""
var cate = ""
var amount = ""
var desc = ""
var respheader = ""
var SEND = false
var apiurl = "https://script.google.com/macros/s/AKfycbysOVA-CmX8jrISj1Tl39ChQJs0vzpYKa2ksde6iLq_WqblQeFKA-Mp9AQ5eMdh9PImyQ/exec"
var geturl = apiurl+"?sheetname="+sheetname

func _ready():
	getdata()
	
func getdata():
	$Label.text = "Fetching: "+sheetname
	$HTTPRequest.request(geturl)
	SEND = false

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if SEND:
		pass
	else:
		respheader = headers
		if response_code == 200:
			$Label.text = "Fetched: "+sheetname
			var data = body.get_string_from_utf8()
			data = parse_json(data)[0]
#			print(data)
			$CASH_IN_HAND.text = "CASH IN HAND:  "+str(data["TOTAL_CASH_IN_HAND"])
			$TOTAL_INCOME.text = "TOTAL INCOME:  "+str(data["TOTAL_INCOME"])
			$TOTAL_EXPENSE.text = "TOTAL EXPENSE: "+str(data["TOTAL_EXPENSE"])
		else:
			print(response_code)
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
	var headers = ["Content-Length: 0"]
	var posturl = apiurl+datasend
	$HTTPRequest.request(posturl,headers,true, HTTPClient.METHOD_POST)
	SEND = true
	$Label.text = "SEND COMPLETED"


func _on_ref_pressed():
	getdata()


