<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="br.edu.insper.TecWeb.*"%>
<%@ page import="java.util.List"%>
<!DOCTYPE html>
<html lang="en">

<style media="screen">
.quadrado {
	height: 100px;
	width: 100px;
	background-color: blue;
}
</style>

<head>
<title>TecWeb JS+HTML+BOOTSTRAP+CSS</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://use.fontawesome.com/releases/v5.3.1/css/all.css"
	integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU"
	crossorigin="anonymous">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
<script src="https://rawgit.com/mattyork/fuzzy/master/fuzzy-min.js"></script>
<script
	src="https://rawgit.com/Glench/fuzzyset.js/master/lib/fuzzyset.js"></script>
<script type="text/javascript">
	//TODO : https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver & https://developer.mozilla.org/en-US/docs/Web/API/DocumentOrShadowRoot/activeElement
<%DAO dao = new DAO();
			List<Note> respDb = dao.getLista();
			StringBuilder fin = new StringBuilder();
			StringBuilder cards = new StringBuilder();
			for (Note x : respDb) {
				if (x.getActive()) {
					fin.append("{");
					fin.append("id:\'" + x.getId() + "\',");
					fin.append("title:\'" + x.getTitle() + "\',");
					fin.append("content:\'" + x.getContent() + "\',");
					fin.append("updateDate:\'" + x.getUpdatedDate() + "\'");
					fin.append("}");
					fin.append(',');

					cards.append("<div class=\"card\" id='" + x.getId()
							+ "' style='display: inline-block;background-color: " + x.getBg() + ";'>")
							.append("<div class=\"card-body\">")
							.append("<a style='float:right' onclick='updateNote(" + x.getId()
									+ ");' data-toggle=\"modal\" data-target=\"#myModalUpdate\"><i class=\"fas fa-pencil-alt\"></i></a><h5 class=\"card-title \" id=\"title\" contenteditable=\"true\">"
									+ x.getTitle() + "</h5><a style='float:right' onclick='deleteNote(" + x.getId()
									+ ");'><i class=\"fas fa-trash\"></i></a>")
							.append("<p class=\"card-text\" id=\"content\" contenteditable=\"true\">" + x.getContent()
									+ "</p>")
							.append("<p class=\"card-text\" id=\"update\">")
							.append("<small class=\"text-muted\">" + x.getUpdatedDate() + "</small>").append("</p>")
							.append("</div>").append("</div>");
				}

			}
			if (fin.length() > 0)
				fin.deleteCharAt(fin.length() - 1);%>
	var toFuzzy = [
<%out.print(fin.toString().replace("/n", ""));%>
	]

	function addToDatabase(id, title, content, update, bg) {
		var card = {}
		card.id = id;
		card.bg = bg;
		card.title = title;
		card.content = content;
		card.updateDate = update;

		toFuzzy.push(card)
		console.log(toFuzzy);

		var xhttp = new XMLHttpRequest();

		xhttp.open("POST", "http://localhost:8080/note", true);
		xhttp.setRequestHeader("Content-type",
				"application/x-www-form-urlencoded");
		xhttp.send("title=" + title + "&content=" + content + "&background=#ffffff");
		console.log(123123)

	}

	function regxMatch() {
		let searchinfo = document.getElementById('textopraprocura').value;
		let matches = []
		let x = document.getElementsByClassName("card");
		for (i = 0; i < x.length; i++) {
			x[i].style.display = "none";
		}
		for (i in toFuzzy) {
			console.log(toFuzzy[i], 1111);
			let regSearch = new RegExp(searchinfo, "g");
			if (regSearch.test(toFuzzy[i].content)
					|| regSearch.test(toFuzzy[i].title)) {
				matches.push(toFuzzy[i].id)
				document.getElementById(toFuzzy[i].id).style.display = 'inline-block'
			}

		}

		console.log(matches);

	}

	function fuzzuezauza() {
		var searchfor = document.getElementById('textopraprocura').value;
		// console.log(typeof searchfor);
		var options = {
			extract : function(element) {
				return element.title;
			}
		};
		// // Filter!
		var filtered = fuzzy.filter(searchfor, toFuzzy, options);
		console.log(filtered);

		// TODO: colocar todos os cards como hidden e passar pelos ids para mostrar eles um por um

	}

	function deleteNote(id) {

		let idd = document.getElementById('modal-info-update').querySelector(
				"#id").value

		var xhttp = new XMLHttpRequest();

		xhttp.open("DELETE", "http://localhost:8080/note", true);
		xhttp.setRequestHeader("Content-type",
				"application/x-www-form-urlencoded");
		xhttp.send("id=" + id);

		let remuved = document.getElementById(id);
		document.getElementById("cards").removeChild(remuved)

	}

	function updateNote(id) {

		var divtest = document.getElementById(id);
		console.log(divtest)
		var divModal = document.getElementById('modal-info-update');

		var d = new Date();

		divModal.querySelector("#title").innerHTML = divtest
				.querySelector("#title").innerHTML
		divModal.querySelector("#content").innerHTML = divtest
				.querySelector("#content").innerHTML
		divModal.querySelector("#update").innerHTML = divtest
				.querySelector("#update").innerHTML
		divModal.querySelector("#id").value = id;

	}

	function sendUpdateNote() {

		var divModal = document.getElementById('modal-info-update');

		let title = divModal.querySelector("#title").innerHTML
		let content = divModal.querySelector("#content").innerHTML
		let idd = divModal.querySelector("#id").value;
		let bg = divModal.querySelector("#bg").value;
		let divtest = document.getElementById(idd)

		divtest.querySelector("#title").innerHTML = divModal
				.querySelector("#title").innerHTML
		divtest.querySelector("#content").innerHTML = divModal
				.querySelector("#content").innerHTML

		divtest.style.backgroundColor = bg

		var xhttp = new XMLHttpRequest();

		xhttp.open("PUT", "http://localhost:8080/note", true);
		xhttp.setRequestHeader("Content-type",
				"application/x-www-form-urlencoded");
		xhttp.send("title=" + title + "&content=" + content + "&background=" + bg
				+ "&id=" + idd);

	}

	function addNote() { 
		//TODO: recarregar pagina ao adicionar uma nota
		var cardsDiv = document.getElementById('cards');
		console.log(cardsDiv.lastChild);
		var divtest = document.getElementById('padrao').cloneNode(true);
		var divModal = document.getElementById('modal-info');

		var d = new Date();

		divtest.querySelector("#title").innerHTML = divModal
				.querySelector("#title").innerHTML
		divtest.querySelector("#content").innerHTML = divModal
				.querySelector("#content").innerHTML
		divtest.querySelector("#update").innerHTML = d.getUTCFullYear()

		divtest.style.display = 'inline-block';
		divtest.id = toFuzzy.length + 1

		addToDatabase(divtest.id, divtest.querySelector("#title").innerHTML,
				divtest.querySelector("#content").innerHTML, divtest
						.querySelector("#update").innerHTML, divModal
						.querySelector("#bg").value);
		cardsDiv.appendChild(divtest);     
	}
	function trueFuzzy() {
		let searchinfo = document.getElementById('textopraprocura').value;
		let search = []
		for (i in toFuzzy) {
			let splited = toFuzzy[i].content.split(" ")
			for (j in splited) {
				search.push(toFuzzy[i].id + "]]]" + splited[j])
			}
		}

		let x = document.getElementsByClassName("card");
		for (i = 0; i < x.length; i++) {
			x[i].style.display = "none";
		}

		a = FuzzySet(search);
		let result = a.get(searchinfo);

		for (i in result) {
			console.log(result[i][1], a)
			document.getElementById(result[i][1].split("]]]")[0]).style.display = 'inline-block'
		}
	}
</script>
</head>

<body>

	<div class="container mt-3">
		<div class="d-flex flex-wrap justify-content-around"></div>
		<div class="row">
			<div class="col-lg-12">
				<h3 class="one">T</h3>
				<div class="float-right">
					<input type="text" name="" value="" id="textopraprocura">
					<button class="btn btn-secondary" type="button" name="button"
						onclick="trueFuzzy()">P.O.C Aproximate Search</button>
					<button class="btn btn-primary" type="button" name="button"
						onclick="regxMatch()">P.O.C RegEx Search</button>
					<button type="button" class="btn btn-info btn-lg"
						data-toggle="modal" data-target="#myModal">Create note</button>
				</div>
				<button class="btn btn-secondary float-left" onclick="">Button</button>
			</div>
		</div>

	</div>
	<!-- Modal -->
	<div class="modal fade" id="myModal" role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content" id="modal-info">
				<h5 class="card-title" id="title" contenteditable="true">Card
					title</h5>
				<p class="card-text" id="content" contenteditable="true">This is
					a wider card with supporting text below as a natural lead-in to
					additional content. This card has even longer content than the
					first to show that equal height action.</p>
				<p class="card-text" id="update">
					<small class="text-muted">Last updated 3 mins ago</small>
				</p>
				<div>
					<button type="button" class="btn btn-default" onclick="addNote()">Okay</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
					<input type="color" id="bg" name="bg" value="#e66465" />
				</div>
				<div></div>


			</div>
		</div>
	</div>
	<div class="modal fade" id="myModalUpdate" role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content" id="modal-info-update">
				<input id='id' name='id' type='hidden'>
				<h5 class="card-title" id="title" contenteditable="true">Card
					title</h5>
				<p class="card-text" id="content" contenteditable="true">This is
					a wider card with supporting text below as a natural lead-in to
					additional content. This card has even longer content than the
					first to show that equal height action.</p>
				<p class="card-text" id="update">
					<small class="text-muted">Last updated 3 mins ago</small>
				</p>
				<div>
					<button type="button" class="btn btn-default"
						onclick="sendUpdateNote()" data-toggle="modal"
						data-target="#myModalUpdate">Okay</button>
					<input type="color" id="bg" name="bg" value="#e66465" />
				</div>
				<div>
					<form action="${pageContext.request.contextPath}/SignUp"
						method="post">
						<input type="submit" name="button1" value="Button 1" />

					</form>
				</div>
				<div></div>


			</div>
		</div>
	</div>
	<div class="card-columns" id='cards'>
		<!-- Mais cards em https://getbootstrap.com/docs/4.0/components/card/-->
		<div class="card" id='padrao' style='display: none;'>
			<div class="card-body">
				<h5 class="card-title" id="title" contenteditable="true">Card
					title</h5>
				<p class="card-text" id="content" contenteditable="true">Card
					Content.</p>
				<p class="card-text" id="update">
					<small class="text-muted">Last updated 3 mins ago</small>
				</p>
			</div>
		</div>
		
		
		<!-- TODO: mudar isso para o padrao mvc ao inves de usar um out.print e logica interna, ver exemplo no teste.jsp(view) e controler(logica) -->

		<%
			out.print(cards.toString());               
		%>
	</div>

</body>

</html>