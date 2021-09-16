package {
	import flash.display.*;
	import flash.events.*;

	public class Img extends MovieClip {

		var orig: Mona = new Mona();
		var bd: Mona = new Mona();
		var bmp: Bitmap;

		var startCounter: int = 0;
		var totalPixels: int = 0;
		var pixelsInImg: int = bd.width * bd.height;
		var holesArr: Array = [];
		var pixelsArr: Array = [];
		var fallingPixels: Array = [];
		var neighborProbability: Number = 0;

		public function Img() {
			bmp = new Bitmap(bd);
			stage.addChild(bmp);


			for (var _row: int = 0; _row < bd.height; _row++) {
				holesArr[_row] = [];
				for (var _col: int = 0; _col < bd.width; _col++) {
					holesArr[_row][_col] = 0;
				}
			}

			stage.addEventListener(Event.ENTER_FRAME, update);
		}



		function getObj(row: int, col: int): Object {
			var pixel: uint = bd.getPixel(col, row);
			return {
				updateable: true,
				pixel: pixel,
				col: col,
				row: row,
				speed: 1,
				fallingSpeed: Math.ceil(Math.random() * 1),
				firstTime: true
			}
		}

		function addPixel(): void {
			var curr: int = 0;
			var numIterations: int = Math.floor(Math.random() * 20);
			while (curr < numIterations) {
				var col: int = Math.random() * bd.width;
				var row: int = Math.random() * bd.height;
				if (holesArr[row] == undefined || holesArr[row][col] == undefined) {
					continue;
				}

				if (holesArr[row][col] == 0) {
					var obj: Object = getObj(row, col);
					curr++;
					totalPixels++;
					fallingPixels.push(obj);
					holesArr[row][col] = 1;
					if (totalPixels >= pixelsInImg) {
						return;
					}
				}
			}
		}

		function addPixelCluster(): void {
			if (totalPixels >= pixelsInImg) {
				return;
			}

			var col: int = Math.random() * bd.width;
			var row: int = Math.random() * bd.height;
			var found: Boolean = false;
			while (!found) {
				if (holesArr[row] != undefined && holesArr[row][col] != undefined) {
					if (holesArr[row][col] == 0) {
						found = true;
						getPixel(row, col);

					}
				}
				if (!found) {
					col = Math.random() * bd.width;
					row = Math.random() * bd.height;
				}
			}

			//}
		}

		function getPixel(row: int, col: int, prob: Number = -1): void {
			if (holesArr[row] == undefined || holesArr[row][col] == undefined) {
				return;
			}
			if (holesArr[row][col] == 0) {
				var obj: Object = getObj(row, col);
				totalPixels++;
				if (Math.random() < 0.5) {
					pixelsArr.unshift(obj);
				} else {
					pixelsArr.push(obj);
				}
				holesArr[row][col] = 1;

				if (totalPixels >= pixelsInImg) {
					return;
				}

				if (pixelsArr.length > 200) {
					return;
				}

				if (prob == -1) {
					prob = neighborProbability;
				}

				//this traverses left and up
				if (Math.random() < 0.5) {
					for (var i: int = -1; i < 2; i++) {
						for (var j: int = -1; j < 2; j++) {
							if (Math.random() < prob) {
								try {

									getPixel(row + i, col + j, prob - 0.001); //
								} catch (e: Error) {
									trace(e);
								}
							}
						}
					}
				} else {
					for (var i: int = 1; i > -2; i--) {
						for (var j: int = 1; j > -2; j--) {
							if (Math.random() < prob) {
								try {
									getPixel(row + i, col + j, prob - 0.001); //
								} catch (e: Error) {
									trace(e);
								}
							}
						}
					}
				}
			}
		}




		function update(e: Event): void {


			if (Number(totalPixels) / Number(pixelsInImg) > 0.95) { //

				if (totalPixels < pixelsInImg) {
					var curr: int = 0;
					var numIterations: int = Math.floor(Math.random() * 1000);

					while (curr < numIterations) {
						var col: int = Math.random() * bd.width;
						var row: int = Math.random() * bd.height;
						if (holesArr[row][col] == 0) {
							curr++;
							getPixel(row, col);
							if (totalPixels >= pixelsInImg) {
								break;
							}
						}

					}
				}


			} else {
				neighborProbability += 0.001;
				addPixel();

				if (pixelsArr.length == 0) {

					addPixelCluster();
				}

			}

			var rndNum: int = Math.random() * 1000;
			for (var h: int = 0; h < rndNum; h++) {
				if (pixelsArr.length == 0) {
					break;
				}
				if (Math.random() < 0.5) {
					fallingPixels.unshift(pixelsArr.pop());
				} else {
					fallingPixels.push(pixelsArr.pop());
				}
			}


			for (var i: int = startCounter; i < fallingPixels.length; i++) {
				var obj: Object = fallingPixels[i];
				if (!obj) {
					continue;
				}
				if (!obj.updateable) {
					continue;
				}
				if (!obj.firstTime) {
					if (holesArr[obj.row] && holesArr[obj.row][obj.col] == 0) {
						//get the original pixel in place
						bd.setPixel(obj.col, obj.row, orig.getPixel(obj.col, obj.row));
					}
					if (holesArr[obj.row] && holesArr[obj.row][obj.col] == 1) {
						bd.setPixel(obj.col, obj.row, 0x000000);
					}
				} else {
					bd.setPixel(obj.col, obj.row, 0x000000);
					obj.firstTime = false;
				}


				obj.row += obj.speed;
				if (obj.speed < 50) {
					obj.speed += obj.fallingSpeed;
				}

				bd.setPixel(obj.col, obj.row, obj.pixel);

				if (obj.row > bd.height) {
					obj.updateable = false;
					//startCounter++;
					fallingPixels[i] = null;
					//pixelsArr.splice(0,1);
				}
			}
		}

	}

}