function stepA() {
	x = document.querySelector('[class="nqmvxvec j83agx80 jnigpg78 cxgpxx05 dflh9lhu sj5x9vvc scb9dxdr odw8uiq3"]')
	x.children[0].click()
}

function stepB(){
	y = document.querySelectorAll('[class="oajrlxb2 g5ia77u1 qu0x051f esr5mh6w e9989ue4 r7d6kgcz rq0escxv nhd2j8a9 j83agx80 p7hjln8o kvgmc6g5 oi9244e8 oygrvhab h676nmdw cxgpxx05 dflh9lhu sj5x9vvc scb9dxdr i1ao9s8h esuyzwwr f1sip0of lzcic4wl l9j0dhe7 abiwlrkh p8dawk7l bp9cbjyn dwo3fsh8 btwxx1t3 pfnyh3mw du4w35lb"]')

	y.forEach(function(el){
		if (el.innerText === "Delete post")
			el.click()
	});
}

function stepC() {
	z = document.querySelector('[class="oi732d6d ik7dh3pa d2edcug0 qv66sw1b c1et5uql a8c37x1j muag1w35 enqfppq2 jq4qci2q a3bd9o3v lrazzd5p bwm1u5wc ni8dbmo4 stjgntxs ltmttdrg g0qnabr5"]')
	z.click();
}

function deletePost() {
	stepA();

	setTimeout(function(){
		stepB();
	},1000);

	setTimeout(function(){
		stepC();
	},1000);
}