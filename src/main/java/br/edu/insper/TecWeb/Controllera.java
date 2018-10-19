package br.edu.insper.TecWeb;

import java.sql.Date;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class Controllera {

	Resources api = new Resources();

	@Value("${mymessage}")
	private String message;

	@GetMapping("/")
	public String index(Model model) {

		model.addAttribute("message", message);
		return "index.jsp";
	}

	@GetMapping("/teste")
	public String responseTemplateTest(Model model) {

		model.addAttribute("message", message);
		return "teste.jsp";
	}

	// ----------------- Importtante, endpoint das notas

	@PostMapping("/note")
	@ResponseBody
	public String addNote(@RequestParam(value = "background", required = true) String bg,
			@RequestParam(value = "title", required = true) String title,
			@RequestParam(value = "content", required = true) String content) {

		System.out.println(title);
		DAO dao = new DAO();

		Integer id = -1;

		if (content.replace("\t", "").replace("\n", "").replace("<br>", "").equals("")) {
			id = dao.adiciona(new Note(bg, title.replace("\t", "").replace("\n", " "),
					api.redditAPI("1", title.replace("\t", "").replace("\n", " ")),
					new Date(System.currentTimeMillis()), new Date(System.currentTimeMillis())));

		} else {
			System.out.println("nadia" + content.replace("\t", "").replace("\n", "").replace("<br>", "") + 123);
			id = dao.adiciona(new Note(bg, title.replace("\t", "").replace("\n", " "),
					content.replace("\t", "").replace("\n", " "), new Date(System.currentTimeMillis()),
					new Date(System.currentTimeMillis())));
		}

		dao.close();

		return "Note " + title.toString() + " adicionada com o id " + id;

	}

	@PutMapping("/note")
	@ResponseBody
	public String editNote(@RequestParam(value = "id", required = true) Integer id,
			@RequestParam(value = "background", required = true) String bg,
			@RequestParam(value = "title", required = true) String title,
			@RequestParam(value = "content", required = true) String content) {
		DAO dao = new DAO();
		if (dao.getListaWhere(id).size() > 0)
			dao.atualiza(new Note(bg, title.replace("\t", "").replace("\n", " "),
					content.replace("\t", "").replace("\n", " "), new Date(System.currentTimeMillis()),
					new Date(System.currentTimeMillis())), id);

		dao.close();

		return "Note " + title.toString() + " atualizada com o id " + id;
	}

	@DeleteMapping("/note/{id}")
	@ResponseBody
	public String deleteNote(@PathVariable(value = "id") Integer id) {

		DAO dao = new DAO();

		dao.delete(id);
		dao.close();
		return "Note deletada com o id " + id;
	}

	// ---------------

	@GetMapping("/ResponseString")
	@ResponseBody
	public String responseString() {

		return api.redditAPI("1", "");
	}

}
