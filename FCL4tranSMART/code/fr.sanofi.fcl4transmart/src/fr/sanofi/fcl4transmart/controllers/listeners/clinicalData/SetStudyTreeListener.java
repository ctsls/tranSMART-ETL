/*******************************************************************************
 * FC&L4tranSMART - Framework Curation And Loading For tranSMART
 * 
 * Copyright (c) 2012 Sanofi.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU Public License v3.0
 * which accompanies this distribution, and is available at
 * http://www.gnu.org/licenses/gpl.html
 * 
 * Contributors:
 *     Sanofi - initial API and implementation
 ******************************************************************************/
package fr.sanofi.fcl4transmart.controllers.listeners.clinicalData;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.Vector;

import org.apache.commons.io.FileUtils;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Listener;

import fr.sanofi.fcl4transmart.controllers.FileHandler;
import fr.sanofi.fcl4transmart.model.classes.TreeNode;
import fr.sanofi.fcl4transmart.model.classes.dataType.ClinicalData;
import fr.sanofi.fcl4transmart.model.classes.workUI.clinicalData.SetStudyTreeUI;
import fr.sanofi.fcl4transmart.model.interfaces.DataTypeItf;
import fr.sanofi.fcl4transmart.ui.parts.WorkPart;

public class SetStudyTreeListener implements Listener{
	private DataTypeItf dataType;
	private SetStudyTreeUI setStudyTreeUI;
	private HashMap<String, String> labels;
	private HashMap<String,Vector<Integer>> columnsDone;//remember what column to omit
	public SetStudyTreeListener(SetStudyTreeUI setStudyTreeUI, DataTypeItf dataType){
		this.setStudyTreeUI=setStudyTreeUI;
		this.dataType=dataType;
		this.labels=new HashMap<String, String>();
	}
	@Override
	public void handleEvent(Event event) {
		// TODO Auto-generated method stub
		this.columnsDone=new HashMap<String,Vector<Integer>>();
		for(File rawFile: ((ClinicalData)this.dataType).getRawFiles()){
			this.columnsDone.put(rawFile.getName(), new Vector<Integer>());
		}
		if(((ClinicalData)this.dataType).getCMF()==null){
			this.setStudyTreeUI.displayMessage("Error: no column mapping file");
			return;
		}
		File file=new File(this.dataType.getPath().toString()+File.separator+this.dataType.getStudy().toString()+".columns.tmp");
		try{			  
			  FileWriter fw = new FileWriter(file);
			  BufferedWriter out = new BufferedWriter(fw);
			  out.write("Filename\tCategory Code\tColumn Number\tData Label\tData Label Source\tControlled Vocab Code\n");
			  
				try{
					BufferedReader br = new BufferedReader(new FileReader(((ClinicalData)this.dataType).getCMF()));
					String line=br.readLine();
					while ((line=br.readLine())!=null){
						if(line.split("\t", -1)[3].compareTo("SUBJ_ID")==0 || line.split("\t", -1)[3].compareTo("VISIT_NAME")==0 || line.split("\t", -1)[3].compareTo("SITE_ID")==0){
							out.write(line+"\n");
							this.columnsDone.get(line.split("\t", -1)[0]).add(Integer.parseInt(line.split("\t", -1)[2]));
						}
						else if(line.split("\t", -1)[3].compareTo("OMIT")!=0 && line.split("\t", -1)[3].compareTo("\\")!=0){
							File rawFile=new File(this.dataType.getPath()+File.separator+line.split("\t", -1)[0]);
							this.labels.put(FileHandler.getColumnByNumber(rawFile, Integer.parseInt(line.split("\t", -1)[2])), line.split("\t", -1)[3]);

						}
					}
					br.close();
				}catch (Exception e){
					this.setStudyTreeUI.displayMessage("File error: "+e.getLocalizedMessage());
					e.printStackTrace();
					out.close();
				}
				
				this.writeLine(this.setStudyTreeUI.getRoot(), out, "");
				
				for(String key: this.columnsDone.keySet()){
					File rawFile=null;
					for(File f: ((ClinicalData)this.dataType).getRawFiles()){
						if(f.getName().compareTo(key)==0){
							rawFile=f;
						}
					}
					if(rawFile!=null){
						for(int i=1; i<=FileHandler.getColumnsNumber(rawFile); i++){
							if(!this.columnsDone.get(key).contains(i)){
								out.write(key+"\t"+""+"\t"+i+"\t"+"OMIT"+"\t\t\n");
							}
						}
					}
				}
				
				out.close();
				try{
					String fileName=((ClinicalData)this.dataType).getCMF().getName();
					((ClinicalData)this.dataType).getCMF().delete();
					File fileDest=new File(this.dataType.getPath()+File.separator+fileName);
					FileUtils.moveFile(file, fileDest);
					((ClinicalData)this.dataType).setCMF(fileDest);
				}
				catch(IOException ioe){
					this.setStudyTreeUI.displayMessage("File error: "+ioe.getLocalizedMessage());
					return;
				}
		  }catch (Exception e){
			  this.setStudyTreeUI.displayMessage("Error: "+e.getLocalizedMessage());
			  e.printStackTrace();
		  }
		this.setStudyTreeUI.displayMessage("Column mapping file updated");
		WorkPart.updateSteps();
		WorkPart.updateFiles();
	}
	public void writeLine(TreeNode node, BufferedWriter out, String path){
		for(TreeNode child: node.getChildren()){
			String newPath=path;
			if(child.isLabel()){
				if(child.getParent().isLabel()){
					String fullname=child.toString();
					String rawFileName=fullname.split(" - ", -1)[0];
					String header=fullname.split(" - ", -1)[1];
					File rawFile=new File(((ClinicalData)this.dataType).getPath()+File.separator+rawFileName);
					try {
						String dataLabel=this.labels.get(header);
						if(dataLabel==null){
							dataLabel=header;
						}
						int columnNumber=FileHandler.getHeaderNumber(rawFile, header);
						out.write(rawFileName+"\t"+path+"\t"+columnNumber+"\t"+"\\"+"\t"+FileHandler.getHeaderNumber(rawFile, child.getParent().toString().split(" - ", -1)[1])+"\t\n");
						this.columnsDone.get(rawFileName).add(columnNumber);
					} catch (IOException e) {
						// TODO Auto-generated catch block
						this.setStudyTreeUI.displayMessage("File error: "+e.getLocalizedMessage());
						e.printStackTrace();
					}
				}else{
					String fullname=child.toString();
					String rawFileName=fullname.split(" - ", -1)[0];
					String header=fullname.split(" - ", -1)[1];
					File rawFile=new File(((ClinicalData)this.dataType).getPath()+File.separator+rawFileName);
					try {
						String dataLabel=this.labels.get(header);
						if(dataLabel==null){
							dataLabel=header;
						}
						int columnNumber=FileHandler.getHeaderNumber(rawFile, header);
						if(child.hasChildren()){
							out.write(rawFileName+"\t"+path+"\t"+columnNumber+"\t"+"DATA_LABEL"+"\t\t\n");
						}
						else{
							out.write(rawFileName+"\t"+path+"\t"+columnNumber+"\t"+dataLabel+"\t\t\n");
						}
						this.columnsDone.get(rawFileName).add(columnNumber);
					} catch (IOException e) {
						// TODO Auto-generated catch block
						this.setStudyTreeUI.displayMessage("File error: "+e.getLocalizedMessage());
						e.printStackTrace();
					}
				}
			}
			else{
				if(path.compareTo("")!=0){
					newPath=path+"+";
				}
				newPath+=child.toString().replace(' ', '_');
			}
			if(child.hasChildren()){
				writeLine(child, out, newPath);
			}
		}
	}
}
