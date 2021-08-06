package com.tojoy.router;

import com.google.auto.service.AutoService;
import com.squareup.javapoet.JavaFile;
import com.squareup.javapoet.MethodSpec;
import com.squareup.javapoet.TypeSpec;

import java.io.IOException;
import java.util.Collections;
import java.util.Set;

import javax.annotation.processing.AbstractProcessor;
import javax.annotation.processing.Filer;
import javax.annotation.processing.ProcessingEnvironment;
import javax.annotation.processing.Processor;
import javax.annotation.processing.RoundEnvironment;
import javax.lang.model.SourceVersion;
import javax.lang.model.element.Element;
import javax.lang.model.element.Modifier;
import javax.lang.model.element.TypeElement;

@AutoService(Processor.class)
public class RouterBindProcessor extends AbstractProcessor {

	public static final String ROOT_INIT = "com.tojoy.router";
	public static final String INIT_CLASS = "RouterInit";
	public static final String INIT_METHOD = "init";

	@Override public synchronized void init(ProcessingEnvironment processingEnvironment) {
		super.init(processingEnvironment);
	}

	//这个方法非常必要，否则将不会执行到process()方法
	@Override public Set<String> getSupportedAnnotationTypes() {
		return Collections.singleton(Router.class.getCanonicalName());
	}

	@Override public SourceVersion getSupportedSourceVersion() {
		return SourceVersion.latestSupported();
	}

	@Override
	public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment env) {
		if (annotations == null || annotations.isEmpty()) {
			return false;
		}
		//使用javapoet来动态生成代码
		MethodSpec.Builder builder = MethodSpec.methodBuilder(INIT_METHOD)
				.addModifiers(Modifier.PUBLIC, Modifier.STATIC)
				.returns(void.class);
		for (Element element : env.getElementsAnnotatedWith(Router.class)) {
			//获取注解中的内容
			String url = element.getAnnotation(Router.class).url();

			TypeElement typeElement = (TypeElement) element;

			//获取全限定类名
			String className = typeElement.getQualifiedName().toString();
			System.out.print("class:" + className + ", url :" + url + "\n");
			builder.addStatement("$T.register($S,$S)", _TJRouter.class, className, url);
		}

		TypeSpec routerInit = TypeSpec.classBuilder(INIT_CLASS)
				.addModifiers(Modifier.PUBLIC, Modifier.FINAL)
				.addMethod(builder.build())
				.build();

		JavaFile javaFile = JavaFile.builder(ROOT_INIT, routerInit)
				.build();

		Filer filer = processingEnv.getFiler();
		try {
			javaFile.writeTo(filer);
		} catch (IOException e) {
			e.printStackTrace();
		}

		return true;
	}
}