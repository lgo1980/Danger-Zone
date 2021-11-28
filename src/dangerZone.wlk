class Empleado {

	var property habilidades = #{}
	var salud = 50
	var property profesion = espia
	const misionesRealizadas = []

	method perderSalud(cantidadSaludAPerder) {
		salud -= cantidadSaludAPerder
	}

	method agregarHabilidades(habilidadesAIncorporar) {
		habilidades.addAll(habilidadesAIncorporar)
	}

	method estaIncapacitado() = salud < profesion.saludCritica()

	method puedeUsarLaHabilidad(habilidad) = !self.estaIncapacitado() && self.poseeHabilidad(habilidad)

	method poseeHabilidad(habilidad) = habilidades.contains(habilidad)

	method finalizarMision(mision) {
		if (salud > 0) self.registrarMision(mision)
	}

	method registrarMision(mision) {
		misionesRealizadas.add(mision)
		self.premiar(mision)
	}

	method premiar(mision) {
		profesion.premiar(self, mision)
	}

	method mostrarSalud() = salud

}

class Jefe inherits Empleado {

	const listaEmpleadosACargo = []

	override method puedeUsarLaHabilidad(habilidad) = super(habilidad) || self.algunSubordinadoPuedeUsarLaHabilidad(habilidad)

	method algunSubordinadoPuedeUsarLaHabilidad(habilidad) = listaEmpleadosACargo.any{ empleado => empleado.puedeUsarLaHabilidad(habilidad) }

	method agregarAlEquipo(empleadosAIncorporar) {
		listaEmpleadosACargo.add(empleadosAIncorporar)
	}

}

class Equipo {

	const empleados = []
	var property tipo = individual

	method agregarAlEquipo(empleadosAIncorporar) {
		empleados.addAll(empleadosAIncorporar)
	}

	method cumplirMision(misionEntrante) {
		if (!self.puedeCumplirMision(misionEntrante)) return throw new Exception(message = "El equipo no puede cumplir la mision ingresada")
		self.recibirDanio(misionEntrante)
		self.registrarMision(misionEntrante)
		return 0
	}

	method puedeCumplirMision(misionEntrante) = misionEntrante.habilidadesNecesarias().all{ habilidad => self.cumpleConLaHabilidad(habilidad) }

	method cumpleConLaHabilidad(habilidad) = empleados.any{ empleado => empleado.puedeUsarLaHabilidad(habilidad) }

	method recibirDanio(mision) = tipo.recibeDanio(mision, empleados)

	method registrarMision(mision) {
		empleados.forEach{ empleado => empleado.finalizarMision(mision)}
	}

}

object individual {

	method recibeDanio(mision, empleados) {
		empleados.get(0).perderSalud(mision.peligrosidad())
	}

}

object grupal {

	method recibeDanio(mision, empleados) {
		empleados.forEach{ empleado => empleado.perderSalud(mision.peligrosidad() / 3)}
	}

}

class Profesion {

	method saludCritica()

	method premiar(empleado, mision)

}

object espia inherits Profesion {

	const saludCritica = 15

	override method saludCritica() = saludCritica

	override method premiar(empleado, mision) {
		empleado.agregarHabilidades(mision.habilidadesNecesarias())
	}

}

class Oficinista inherits Profesion {

	var cantidadEstrellas = 0
	const saludCritica = 40 - (5 * cantidadEstrellas)

	override method saludCritica() = saludCritica

	override method premiar(empleado, mision) {
		self.adquirirEstrella()
		if (cantidadEstrellas >= 3) self.cambiarAEspia(empleado)
	}

	method adquirirEstrella() {
		cantidadEstrellas += 1
	}

	method cambiarAEspia(empleado) {
		empleado.profesion(espia)
	}

	method mostrarEstrellas() = cantidadEstrellas

}

class Mision {

	const habilidadesNecesarias = []
	const property peligrosidad

	method agregarHabilidades(habilidadesAIncorporar) {
		habilidadesNecesarias.addAll(habilidadesAIncorporar)
	}

	method habilidadesNecesarias() = habilidadesNecesarias

}

